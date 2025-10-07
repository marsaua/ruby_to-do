console.log("=== THEME.JS LOADED ===");

document.addEventListener("DOMContentLoaded", () => {
  console.log("=== DOM READY ===");

  const button = document.querySelector(".theme-switcher");
  console.log("Button found:", button);

  if (button) {
    button.addEventListener("click", () => {
      console.log("BUTTON CLICKED!");
      alert("Theme button works!");
    });
  }
});
