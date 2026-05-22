(function () {
  var key = "codexworkbench.lang";

  function normalize(value) {
    return value === "en" ? "en" : "zh";
  }

  function preferredLanguage() {
    try {
      var saved = localStorage.getItem(key);
      if (saved) {
        return normalize(saved);
      }
    } catch (error) {
      // Ignore storage restrictions in private browsing or embedded webviews.
    }

    return (navigator.language || "").toLowerCase().indexOf("zh") === 0 ? "zh" : "en";
  }

  function applyLanguage(language) {
    var next = normalize(language);
    document.documentElement.dataset.lang = next;
    document.documentElement.lang = next === "zh" ? "zh-CN" : "en";

    document.querySelectorAll("[data-lang-toggle]").forEach(function (button) {
      var active = button.getAttribute("data-lang-toggle") === next;
      button.setAttribute("aria-pressed", active ? "true" : "false");
    });

    try {
      localStorage.setItem(key, next);
    } catch (error) {
      // The switch still works for the current page even if persistence fails.
    }
  }

  applyLanguage(preferredLanguage());

  document.addEventListener("DOMContentLoaded", function () {
    document.querySelectorAll("[data-lang-toggle]").forEach(function (button) {
      button.addEventListener("click", function () {
        applyLanguage(button.getAttribute("data-lang-toggle"));
      });
    });
  });
})();
