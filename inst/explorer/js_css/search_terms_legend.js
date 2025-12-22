// Search terms textarea with horizontal color legend
(function() {
    const MAX_LINES = 6;
    const COLORS = ['red', 'blue', 'green', 'purple', 'orange', 'gray'];

    function updateLegend(textarea, legend) {
        const lines = textarea.value.split('\n');

        // Clear existing legend boxes
        legend.innerHTML = '';

        // Create legend boxes for non-empty lines only
        let colorIndex = 0;
        for (let i = 0; i < lines.length && colorIndex < MAX_LINES; i++) {
            if (lines[i].trim() !== '') {
                const box = document.createElement('div');
                box.className = 'legend-box';
                box.style.backgroundColor = COLORS[colorIndex % COLORS.length];
                box.title = 'Term ' + (colorIndex + 1);
                legend.appendChild(box);
                colorIndex++;
            }
        }
    }

    function countNonEmptyLines(lines) {
        return lines.filter(line => line.trim() !== '').length;
    }

    function limitNonEmptyLines(textarea) {
        const lines = textarea.value.split('\n');
        let nonEmptyCount = 0;
        const limitedLines = [];

        for (let i = 0; i < lines.length; i++) {
            if (lines[i].trim() === '') {
                // Always allow empty lines
                limitedLines.push(lines[i]);
            } else if (nonEmptyCount < MAX_LINES) {
                // Allow non-empty lines up to MAX_LINES
                limitedLines.push(lines[i]);
                nonEmptyCount++;
            }
            // Skip non-empty lines beyond MAX_LINES
        }

        textarea.value = limitedLines.join('\n');
    }

    function init() {
        const textarea = document.getElementById('search_terms_area');
        const legend = document.getElementById('search_terms_legend');

        if (!textarea || !legend) {
            setTimeout(init, 100);
            return;
        }

        // Initial update
        updateLegend(textarea, legend);

        // Listen for input events
        textarea.addEventListener('input', function() {
            limitNonEmptyLines(textarea);
            updateLegend(textarea, legend);
            if (window.Shiny) {
                Shiny.setInputValue('search_terms_area', textarea.value);
            }
        });

        // Handle paste events
        textarea.addEventListener('paste', function() {
            setTimeout(function() {
                limitNonEmptyLines(textarea);
                updateLegend(textarea, legend);
                if (window.Shiny) {
                    Shiny.setInputValue('search_terms_area', textarea.value);
                }
            }, 0);
        });

        // Prevent Enter once 6 non-empty terms exist
        textarea.addEventListener('keydown', function(e) {
            if (e.key === 'Enter') {
                const lines = textarea.value.split('\n');
                const nonEmptyCount = countNonEmptyLines(lines);
                if (nonEmptyCount >= MAX_LINES) {
                    e.preventDefault();
                }
            }
        });

        // Set initial Shiny value
        if (window.Shiny) {
            Shiny.setInputValue('search_terms_area', textarea.value);
        }
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }
})();
