// Document Find - client-side search within document viewer
// Operates on text nodes, preserves existing R highlighting
// Uses event delegation for reliability with Shiny DOM updates

(function() {
    class DocumentFind {
        constructor() {
            this.originalContent = null;
            this.matches = [];
            this.currentMatchIndex = -1;
        }

        // Get fresh DOM references each time (Shiny recreates elements)
        getElements() {
            return {
                content: document.querySelector('.doc-content-searchable'),
                input: document.getElementById('docFindInput'),
                presets: document.getElementById('docFindPresets'),
                prevBtn: document.getElementById('docFindPrev'),
                nextBtn: document.getElementById('docFindNext'),
                info: document.getElementById('docFindInfo'),
                caseSensitive: document.getElementById('docFindCaseSensitive')
            };
        }

        init(terms) {
            const els = this.getElements();

            if (!els.content || !els.input) {
                return;
            }

            // Capture original content (with R's highlighting)
            this.originalContent = els.content.innerHTML;
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

            // Restore original content (R's highlighting)
            els.content.innerHTML = this.originalContent;
            this.matches = [];
            this.currentMatchIndex = -1;

            try {
                const caseSensitive = els.caseSensitive && els.caseSensitive.checked;
                const regex = new RegExp(searchTerm, caseSensitive ? 'g' : 'gi');
                this.highlightInElement(els.content, regex);
                this.updateUI();
            } catch (error) {
                if (els.info) {
                    els.info.textContent = 'Invalid pattern';
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
            if (els.content && this.originalContent) {
                els.content.innerHTML = this.originalContent;
            }
            this.matches = [];
            this.currentMatchIndex = -1;
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
