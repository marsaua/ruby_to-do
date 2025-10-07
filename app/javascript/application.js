// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import "@hotwired/stimulus";
import "@hotwired/stimulus-loading";

// Start Active Storage (required for Action Text attachments)
import * as ActiveStorage from "@rails/activestorage";
ActiveStorage.start();

// Import Stimulus and auto-load controllers
import { Application } from "@hotwired/stimulus";

const application = Application.start();
application.debug = false;
window.Stimulus = application;

console.log("=== APPLICATION.JS LOADED ===");

// Theme switcher - use Turbo events instead of DOMContentLoaded
document.addEventListener("turbo:load", () => {
  console.log("=== TURBO LOAD EVENT ===");

  // Initialize theme
  const savedTheme = localStorage.getItem("theme") || "light";
  document.documentElement.setAttribute("data-bs-theme", savedTheme);

  const switcher = document.querySelector(".theme-switcher");
  if (switcher) {
    switcher.textContent = savedTheme === "dark" ? "☀️" : "🌙";
    console.log("Theme initialized:", savedTheme);
  }
});

// Theme toggle handler using event delegation
document.addEventListener("click", (e) => {
  if (e.target.closest(".theme-switcher")) {
    console.log("=== THEME BUTTON CLICKED ===");

    const currentTheme =
      document.documentElement.getAttribute("data-bs-theme") || "light";
    const newTheme = currentTheme === "dark" ? "light" : "dark";

    document.documentElement.setAttribute("data-bs-theme", newTheme);
    localStorage.setItem("theme", newTheme);

    const switcher = document.querySelector(".theme-switcher");
    if (switcher) {
      switcher.textContent = newTheme === "dark" ? "☀️" : "🌙";
    }

    console.log("Theme switched to:", newTheme);
  }
});

// Load Trix and ActionText dynamically
document.addEventListener("turbo:load", async () => {
  if (!window.Trix) {
    const TrixModule = await import("trix");
    window.Trix = TrixModule.default || TrixModule;
    await import("@rails/actiontext");
  }
});
