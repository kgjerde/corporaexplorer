// Dynamic column width adjustment with drag support
$(document).ready(function() {
    var leftCol, rightCol, handle, isDragging = false;
    var parentRow, containerLeft, containerWidth;

    $(document).on('shiny:connected', function() {
        leftCol = $('.col-sm-6').first();
        rightCol = $('.col-sm-6').last();
        parentRow = leftCol.parent();

        // Position handle relative to left column instead of row
        leftCol.css('position', 'relative');

        // Create absolutely positioned drag handle (appended to left column)
        handle = $('<div class="column-resize-handle"></div>');
        leftCol.append(handle);

        // Position handle centered in the gap between columns
        function positionHandle() {
            handle.css('right', '-12px');
        }

        // Apply initial value
        var initialValue = $('#column_width').val() || 50;
        if (initialValue != 50) {
            updateColumnWidths(initialValue);
        }
        positionHandle();

        // Mouse down on handle
        handle.on('mousedown', function(e) {
            isDragging = true;
            containerLeft = parentRow.offset().left;
            containerWidth = parentRow.width();
            $('body').css('cursor', 'col-resize');
            $('body').css('user-select', 'none');
            e.preventDefault();
        });

        // Double-click to reset to initial value
        handle.on('dblclick', function(e) {
            updateColumnWidths(initialValue);
            positionHandle();
            var slider = $('#column_width').data('ionRangeSlider');
            if (slider) {
                slider.update({ from: initialValue });
            }
            Shiny.setInputValue('column_width', initialValue, {priority: 'event'});
        });

        // Mouse move
        $(document).on('mousemove', function(e) {
            if (!isDragging) return;

            var mouseX = e.pageX - containerLeft;
            var pct = (mouseX / containerWidth) * 100;

            // Clamp to 30-70% (matches sidebar slider range)
            pct = Math.max(30, Math.min(70, pct));
            pct = Math.round(pct);

            updateColumnWidths(pct);
            positionHandle();
        });

        // Mouse up
        $(document).on('mouseup', function() {
            if (isDragging) {
                isDragging = false;
                $('body').css('cursor', '');
                $('body').css('user-select', '');

                // Sync slider - update both Shiny and the visual slider
                var leftPct = Math.round((leftCol.outerWidth() / parentRow.width()) * 100);
                var slider = $('#column_width').data('ionRangeSlider');
                if (slider) {
                    slider.update({ from: leftPct });
                }
                Shiny.setInputValue('column_width', leftPct, {priority: 'event'});
            }
        });

        // Slider changes
        $(document).on('shiny:inputchanged', function(event) {
            if (event.name === 'column_width') {
                updateColumnWidths(event.value);
                setTimeout(positionHandle, 10);
            }
        });

        // Reposition on window resize
        $(window).on('resize', positionHandle);
    });

    function updateColumnWidths(leftPercent) {
        var rightPercent = 100 - leftPercent;
        leftCol.css({ 'flex': '0 0 ' + leftPercent + '%', 'max-width': leftPercent + '%' });
        rightCol.css({ 'flex': '0 0 ' + rightPercent + '%', 'max-width': rightPercent + '%' });
    }
});
