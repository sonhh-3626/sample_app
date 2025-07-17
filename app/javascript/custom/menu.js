// Adds a toggle listener for a given element and its associated menu.
function addToggleListener(selectedId, menuId, toggleClass) {
  const selectedElement = document.querySelector(`#${selectedId}`);
  if (selectedElement) {
    selectedElement.addEventListener("click", function(event) {
      event.preventDefault();
      const menu = document.querySelector(`#${menuId}`);
      if (menu) {
        menu.classList.toggle(toggleClass);
      }
    });
  }
}

// Add toggle listeners to listen for clicks when the page loads or navigates.
document.addEventListener("turbo:load", function() {
  addToggleListener("hamburger", "navbar-menu", "collapse");
  addToggleListener("account", "dropdown-menu", "active");
});
