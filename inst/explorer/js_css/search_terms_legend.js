// Search terms and highlight terms textareas with color legends
(function() {
    const MAX_SEARCH_TERMS = 6;
    const COLORS = ['red', 'blue', 'green', 'purple', 'orange', 'gray'];

    function countNonEmptyLines(text) {
        if (!text) return 0;
        return text.split('\n').filter(line => line.trim() !== '').length;
    }

    function updateLegend(textarea, legend, startIndex, maxTerms) {
        if (!textarea || !legend) return;

        const lines = textarea.value.split('\n');
        legend.innerHTML = '';

        let colorIndex = 0;
        for (let i = 0; i < lines.length && (maxTerms === null || colorIndex < maxTerms); i++) {
            if (lines[i].trim() !== '') {
                const box = document.createElement('div');
                box.className = 'legend-box';
                box.style.backgroundColor = COLORS[(startIndex + colorIndex) % COLORS.length];
                box.title = 'Term ' + (startIndex + colorIndex + 1);
                legend.appendChild(box);
                colorIndex++;
            }
        }
    }

    function limitNonEmptyLines(textarea, maxLines) {
        const lines = textarea.value.split('\n');
        let nonEmptyCount = 0;
        const limitedLines = [];

        for (let i = 0; i < lines.length; i++) {
            if (lines[i].trim() === '') {
                limitedLines.push(lines[i]);
            } else if (nonEmptyCount < maxLines) {
                limitedLines.push(lines[i]);
                nonEmptyCount++;
            }
        }

        textarea.value = limitedLines.join('\n');
    }

    function init() {
        const searchTextarea = document.getElementById('search_terms_area');
        const searchLegend = document.getElementById('search_terms_legend');
        const highlightTextarea = document.getElementById('highlight_terms_area');
        const highlightLegend = document.getElementById('highlight_terms_legend');

        if (!searchTextarea || !searchLegend) {
            setTimeout(init, 100);
            return;
        }

        function updateAllLegends() {
            // Search terms legend: starts at index 0
            updateLegend(searchTextarea, searchLegend, 0, MAX_SEARCH_TERMS);

            // Highlight terms legend: starts after search terms
            if (highlightTextarea && highlightLegend) {
                const searchTermCount = countNonEmptyLines(searchTextarea.value);
                updateLegend(highlightTextarea, highlightLegend, searchTermCount, null);
            }
        }

        // Initial update
        updateAllLegends();

        // Search terms: input events
        searchTextarea.addEventListener('input', function() {
            limitNonEmptyLines(searchTextarea, MAX_SEARCH_TERMS);
            updateAllLegends();
            if (window.Shiny) {
                Shiny.setInputValue('search_terms_area', searchTextarea.value);
            }
        });

        searchTextarea.addEventListener('paste', function() {
            setTimeout(function() {
                limitNonEmptyLines(searchTextarea, MAX_SEARCH_TERMS);
                updateAllLegends();
                if (window.Shiny) {
                    Shiny.setInputValue('search_terms_area', searchTextarea.value);
                }
            }, 0);
        });

        searchTextarea.addEventListener('keydown', function(e) {
            if (e.key === 'Enter') {
                if (countNonEmptyLines(searchTextarea.value) >= MAX_SEARCH_TERMS) {
                    e.preventDefault();
                }
            }
        });

        // Highlight terms: input events (only update highlight legend)
        if (highlightTextarea && highlightLegend) {
            highlightTextarea.addEventListener('input', function() {
                updateAllLegends();
            });

            highlightTextarea.addEventListener('paste', function() {
                setTimeout(updateAllLegends, 0);
            });
        }

        // Set initial Shiny value
        if (window.Shiny) {
            Shiny.setInputValue('search_terms_area', searchTextarea.value);
        }
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }
})();
