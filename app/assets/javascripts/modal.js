document.addEventListener("DOMContentLoaded", function () {
    var rootEl = document.documentElement;
    var $modals = getAll(".modal");
    var $modalButtons = getAll(".modal-button");
    var $modalCloses = getAll(
        ".modal-background, .modal-button-close, .modal-close, .modal-card-head .delete, .modal-card-foot .button"
    );

    if ($modalButtons.length > 0) {
        $modalButtons.forEach(function ($el) {
            $el.addEventListener("click", function () {
                var target = $el.dataset.target;
                var $target = document.getElementById(target);
                var toggle = $el.dataset.toggle;
                var $toggle = document.getElementById(toggle);
                openModal(rootEl, $target, $toggle);
            });
        });
    }

    if ($modalCloses.length > 0) {
        $modalCloses.forEach(function ($el) {
            $el.addEventListener("click", function () {
                closeModals();
            });
        });
    }

    document.addEventListener("keydown", function (event) {
        var e = event || window.event;
        if (e.keyCode === 27) {
            closeModals();
        }
    });

    function closeModals() {
        rootEl.classList.remove("is-clipped");
        console.log($modals)
        $modals.forEach(function ($el) {
            $el.classList.add("fadeOut");
            setTimeout(function () {
                $el.classList.remove("is-active", "fadeOut", "in");
                $($el).removeAttr("style");
                $($el).hide();
            }, 300);
        });
        $($modals).parents("body").removeClass("modal-open").removeAttr("style")
    }

    function getAll(selector) {
        return Array.prototype.slice.call(
            document.querySelectorAll(selector),
            0
        );
    }
});

function openModal(rootEl, modalEl, toggleEl) {
    if (!rootEl || !modalEl) {
        throw new Error("unable to open modal");
    }

    rootEl.classList.add("is-clipped");
    modalEl.classList.add("is-active", "fadeIn");
    modalEl.classList.remove("fadeOut");
    $(modalEl).css("display", "flex")
    if (toggleEl) {
        toggleEl.classList.add("fadeOut");
        setTimeout(function () {
            toggleEl.classList.remove("is-active", "fadeIn");
        }, 300);
    }
}
