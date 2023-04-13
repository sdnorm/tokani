import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="menu"
export default class extends Controller {
  toggleMenu() {
    document.querySelector('#slideoverContainer').classList.toggle('invisible');

    document.querySelector('#slideover-bg').classList.toggle('opacity-0');
    document.querySelector('#slideover-bg').classList.toggle('opacity-50');

    document.querySelector('#slideover').classList.toggle('-translate-x-full');

    document.querySelector('#slideover').classList.toggle('h-full');
  }
}
