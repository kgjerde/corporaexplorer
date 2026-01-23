// Document Find - client-side search within document viewer
// Operates on text nodes, preserves existing R highlighting
// Uses event delegation for reliability with Shiny DOM updates

(function() {
    /**
     * Convert ASCII-only regex shortcuts to Unicode-aware equivalents.
     * Makes \w, \W, \b, \B, \d, \D work with all Unicode scripts.
     *
     * @param {string} pattern - The regex pattern from user input
     * @returns {string} - Pattern with Unicode-aware replacements
     * @throws {Error} - If browser doesn't support required features or pattern is invalid
     */
    function unicodifyRegex(pattern) {
      // Validation
      if (!pattern || typeof pattern !== 'string') {
        throw new Error('Pattern must be a non-empty string');
      }

      // Feature detection - check for Unicode lookbehind support
      if (unicodifyRegex._supportsLookbehinds === null) {
        try {
          new RegExp('(?<=a)b', 'u');
          unicodifyRegex._supportsLookbehinds = true;
        } catch (e) {
          throw new Error(
            'Your browser doesn\'t support Unicode regex lookbehinds. ' +
            'Please update to: Chrome 62+, Firefox 78+, Safari 16.4+, or Edge 79+'
          );
        }
      }

      // Unicode-aware character classes
      const WORD_CHAR = '[\\p{L}\\p{N}_]';
      const NON_WORD_CHAR = '[^\\p{L}\\p{N}_]';
      const DIGIT = '\\p{Nd}';
      const NON_DIGIT = '\\P{Nd}';

      // Unicode-aware word boundaries using lookbehinds/lookaheads
      const WORD_BOUNDARY =
        '(?:(?<=[\\p{L}\\p{N}_])(?![\\p{L}\\p{N}_])|(?<![\\p{L}\\p{N}_])(?=[\\p{L}\\p{N}_]))';
      const NON_WORD_BOUNDARY =
        '(?:(?<=[\\p{L}\\p{N}_])(?=[\\p{L}\\p{N}_])|(?<![\\p{L}\\p{N}_])(?![\\p{L}\\p{N}_]))';

      // Unique placeholder using multiple private-use characters
      const PLACEHOLDER = '\uE000\uE001\uE002';

      let result = '';
      let i = 0;
      let inCharClass = false;
      let escaped = false;

      while (i < pattern.length) {
        const char = pattern[i];

        // Handle escaped sequences
        if (escaped) {
          escaped = false;

          // Double backslash - literal backslash
          if (char === '\\') {
            result += PLACEHOLDER;
            i++;
            continue;
          }

          // Escaped bracket - keep as-is
          if (char === '[' || char === ']') {
            result += '\\' + char;
            i++;
            continue;
          }

          // Handle shortcuts based on context
          if (inCharClass) {
            // Inside character class [...]
            switch (char) {
              case 'w':
                result += '\\p{L}\\p{N}_';
                i++;
                continue;
              case 'W':
                console.warn('\\W inside character class may not work as expected with Unicode. Consider using negated class outside brackets.');
                result += '\\' + char;
                i++;
                continue;
              case 'd':
                result += '\\p{Nd}';
                i++;
                continue;
              case 'D':
                console.warn('\\D inside character class may not work as expected with Unicode. Consider using negated class outside brackets.');
                result += '\\' + char;
                i++;
                continue;
              // \b and \B inside [...] have different meanings (backspace/literal B)
              default:
                result += '\\' + char;
                i++;
                continue;
            }
          } else {
            // Outside character class
            switch (char) {
              case 'w':
                result += WORD_CHAR;
                i++;
                continue;
              case 'W':
                result += NON_WORD_CHAR;
                i++;
                continue;
              case 'b':
                result += WORD_BOUNDARY;
                i++;
                continue;
              case 'B':
                result += NON_WORD_BOUNDARY;
                i++;
                continue;
              case 'd':
                result += DIGIT;
                i++;
                continue;
              case 'D':
                result += NON_DIGIT;
                i++;
                continue;
              default:
                result += '\\' + char;
                i++;
                continue;
            }
          }
        }

        // Start of escape sequence
        if (char === '\\') {
          escaped = true;
          i++;
          continue;
        }

        // Track character class boundaries (only for non-escaped brackets)
        if (char === '[') {
          inCharClass = true;
          result += char;
          i++;
          continue;
        }

        if (char === ']') {
          inCharClass = false;
          result += char;
          i++;
          continue;
        }

        // Regular character
        result += char;
        i++;
      }

      // Check for incomplete escape at end
      if (escaped) {
        console.warn('Pattern ends with incomplete escape sequence');
        result += '\\';
      }

      // Warn if character class wasn't closed
      if (inCharClass) {
        console.warn('Unclosed character class in pattern - regex may be invalid');
      }

      // Restore escaped backslashes
      result = result.replace(new RegExp(PLACEHOLDER, 'g'), '\\\\');

      return result;
    }

    // Cache feature detection result (null = not checked yet)
    unicodifyRegex._supportsLookbehinds = null;

    /**
     * Safe wrapper that catches errors and provides helpful messages
     *
     * @param {string} pattern - The regex pattern from user input
     * @param {string} flags - Regex flags (default: 'giu')
     * @returns {RegExp} - Compiled Unicode-aware regex
     */
    function createUnicodeRegex(pattern, flags = 'giu') {
      try {
        // Ensure 'u' flag is always present for Unicode support
        if (!flags.includes('u')) {
          flags += 'u';
        }

        const unicodePattern = unicodifyRegex(pattern);
        return new RegExp(unicodePattern, flags);
      } catch (error) {
        // Provide context in error message
        if (error.message.includes('browser')) {
          throw error; // Re-throw browser compatibility errors as-is
        }
        throw new Error(`Invalid regex pattern: ${error.message}`);
      }
    }

    class DocumentFind {
        constructor() {
            this.matches = [];
            this.currentMatchIndex = -1;
        }

        // Get fresh DOM references each time (Shiny recreates elements)
        getElements() {
            return {
                content: document.getElementById('doc_tekst'),
                input: document.getElementById('docFindInput'),
                presets: document.getElementById('docFindPresets'),
                prevBtn: document.getElementById('docFindPrev'),
                nextBtn: document.getElementById('docFindNext'),
                info: document.getElementById('docFindInfo'),
                caseSensitive: document.getElementById('docFindCaseSensitive')
            };
        }

        // Remove JS highlights by unwrapping spans, preserving R's <mark> highlighting
        removeHighlights() {
            const els = this.getElements();
            if (!els.content) return;

            els.content.querySelectorAll('.doc-find-match').forEach(span => {
                span.replaceWith(span.textContent);
            });
            els.content.normalize(); // Merge adjacent text nodes
            this.matches = [];
            this.currentMatchIndex = -1;
        }

        init(terms) {
            const els = this.getElements();

            if (!els.content || !els.input) {
                return;
            }

            // Reset state (no need to capture content anymore)
            this.matches = [];
            this.currentMatchIndex = -1;

            // Clear previous search
            els.input.value = '';

            this.populatePresets(els.presets, terms || []);
            this.updateUI();
        }

        populatePresets(presetsEl, terms) {
            if (!presetsEl) return;

            // Clear existing options
            presetsEl.innerHTML = '';

            // Add empty option
            const emptyOpt = document.createElement('option');
            emptyOpt.value = '';
            emptyOpt.textContent = 'Search terms';
            presetsEl.appendChild(emptyOpt);

            // Add "Any term" option if multiple terms
            if (terms.length > 1) {
                const anyOpt = document.createElement('option');
                anyOpt.value = '(' + terms.join('|') + ')';
                anyOpt.textContent = 'Any term';
                presetsEl.appendChild(anyOpt);
            }

            // Add individual terms
            terms.forEach(term => {
                const opt = document.createElement('option');
                opt.value = term;
                opt.textContent = term.length > 12 ? term.substring(0, 12) + '...' : term;
                presetsEl.appendChild(opt);
            });
        }

        search() {
            const els = this.getElements();
            if (!els.content || !els.input) return;

            const searchTerm = els.input.value.trim();

            if (!searchTerm) {
                this.clear();
                return;
            }

            // Remove any existing JS highlights (preserves R's <mark> highlighting)
            this.removeHighlights();

            try {
                const caseSensitive = els.caseSensitive && els.caseSensitive.checked;
                const flags = caseSensitive ? 'gu' : 'giu';
                const regex = createUnicodeRegex(searchTerm, flags);
                this.highlightInElement(els.content, regex);
                this.updateUI();
            } catch (error) {
                if (els.info) {
                    els.info.textContent = error.message.includes('browser')
                        ? 'Browser not supported'
                        : 'Invalid pattern';
                    els.info.style.color = '#dc3545';
                }
            }
        }

        highlightInElement(element, regex) {
            const walker = document.createTreeWalker(element, NodeFilter.SHOW_TEXT);

            const nodesToReplace = [];
            let node;

            while ((node = walker.nextNode())) {
                if (node.nodeValue.trim().length === 0) continue;

                const text = node.nodeValue;
                const matches = [...text.matchAll(regex)];
                if (matches.length > 0) {
                    nodesToReplace.push({ node, matches, text });
                }
            }

            nodesToReplace.forEach(({ node, matches, text }) => {
                const fragment = document.createDocumentFragment();
                let lastIndex = 0;

                matches.forEach(match => {
                    const matchStart = match.index;
                    const matchEnd = matchStart + match[0].length;

                    if (matchStart > lastIndex) {
                        fragment.appendChild(
                            document.createTextNode(text.substring(lastIndex, matchStart))
                        );
                    }

                    const highlight = document.createElement('span');
                    highlight.className = 'doc-find-match';
                    highlight.textContent = match[0];
                    fragment.appendChild(highlight);
                    this.matches.push(highlight);

                    lastIndex = matchEnd;
                });

                if (lastIndex < text.length) {
                    fragment.appendChild(
                        document.createTextNode(text.substring(lastIndex))
                    );
                }

                node.parentNode.replaceChild(fragment, node);
            });

            if (this.matches.length > 0) {
                this.currentMatchIndex = 0;
                this.highlightCurrentMatch();
            }
        }

        highlightCurrentMatch() {
            this.matches.forEach((match, i) => {
                const isCurrent = i === this.currentMatchIndex;
                match.classList.toggle('current', isCurrent);
                if (isCurrent) match.scrollIntoView({ behavior: 'smooth', block: 'center' });
            });
        }

        navigate(delta) {
            if (this.matches.length === 0) return;
            this.currentMatchIndex = (this.currentMatchIndex + delta + this.matches.length) % this.matches.length;
            this.highlightCurrentMatch();
            this.updateUI();
        }

        updateUI() {
            const els = this.getElements();
            if (!els.info) return;

            const hasMatches = this.matches.length > 0;

            if (els.prevBtn) els.prevBtn.disabled = !hasMatches;
            if (els.nextBtn) els.nextBtn.disabled = !hasMatches;

            if (hasMatches) {
                els.info.textContent = `${this.currentMatchIndex + 1} / ${this.matches.length}`;
                els.info.style.color = '#666';
            } else if (els.input && els.input.value.trim()) {
                els.info.textContent = '0';
                els.info.style.color = '#999';
            } else {
                els.info.textContent = '';
            }
        }

        clear() {
            const els = this.getElements();
            if (els.input) els.input.value = '';
            this.removeHighlights();
            this.updateUI();
        }
    }

    // Create global instance
    window.docFind = new DocumentFind();

    // Event delegation - attach once to document, works regardless of DOM changes
    let debounceTimer;

    document.addEventListener('input', function(e) {
        if (e.target.id === 'docFindInput') {
            clearTimeout(debounceTimer);
            debounceTimer = setTimeout(() => window.docFind.search(), 300);
        }
    });

    document.addEventListener('change', function(e) {
        if (e.target.id === 'docFindPresets') {
            const value = e.target.value;
            if (value) {
                const els = window.docFind.getElements();
                if (els.input) {
                    els.input.value = value;
                    window.docFind.search();
                }
            }
            e.target.selectedIndex = 0;
        }
        if (e.target.id === 'docFindCaseSensitive') {
            const els = window.docFind.getElements();
            if (els.input && els.input.value.trim()) {
                window.docFind.search();
            }
        }
    });

    document.addEventListener('click', function(e) {
        if (e.target.id === 'docFindPrev') {
            window.docFind.navigate(-1);
        }
        if (e.target.id === 'docFindNext') {
            window.docFind.navigate(1);
        }
    });

    document.addEventListener('keydown', function(e) {
        if (e.target.id === 'docFindInput') {
            if (e.key === 'Enter') {
                e.preventDefault();
                window.docFind.navigate(e.shiftKey ? -1 : 1);
            }
            if (e.key === 'Escape') {
                window.docFind.clear();
            }
        }
    });

    // Initialize when document tab becomes visible
    window.initDocFind = function(terms) {
        setTimeout(() => window.docFind.init(terms), 100);
    };
})();
