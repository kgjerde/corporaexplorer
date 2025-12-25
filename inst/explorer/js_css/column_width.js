// Dynamic column width adjustment
$(document).ready(function() {
    // Apply initial value on page load
    $(document).on('shiny:connected', function() {
        var initialValue = $('#column_width').val();
        if (initialValue && initialValue != 50) {
            updateColumnWidths(initialValue);
        }
    });

    // Listen for slider changes
    $(document).on('change', '#column_width', function() {
        updateColumnWidths($(this).val());
    });

    // Also listen for Shiny input updates
    $(document).on('shiny:inputchanged', function(event) {
        if (event.name === 'column_width') {
            updateColumnWidths(event.value);
        }
    });
});

function updateColumnWidths(leftPercent) {
    var rightPercent = 100 - leftPercent;

    // Find the main row's columns
    var leftCol = $('.col-sm-6').first();
    var rightCol = $('.col-sm-6').last();

    // Apply percentage widths
    leftCol.css({
        'flex': '0 0 ' + leftPercent + '%',
        'max-width': leftPercent + '%'
    });

    rightCol.css({
        'flex': '0 0 ' + rightPercent + '%',
        'max-width': rightPercent + '%'
    });
}
