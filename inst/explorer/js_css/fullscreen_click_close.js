(function() {
    document.addEventListener('click', function(e) {
        // Only left-click
        if (e.button !== 0) return;

        // Check if clicking on corpus map plot
        var plotOutput = e.target.closest('#korpuskart');
        if (!plotOutput) return;

        // Check if in fullscreen mode (class on body)
        if (!document.body.classList.contains('bslib-has-full-screen')) return;

        // Delay close so Shiny processes the click first
        setTimeout(function() {
            var exitBtn = document.querySelector('.bslib-full-screen-exit');
            if (exitBtn) exitBtn.click();
        }, 400);
    });
})();
