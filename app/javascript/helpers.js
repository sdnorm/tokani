export function getMetaValue(name) {
  const element = findElement(document.head, `meta[name="${name}"]`)
  if (element) {
    return element.getAttribute("content")
  }
}

export function findElement(root, selector) {
  if (typeof root == "string") {
    selector = root
    root = document
  }
  return root.querySelector(selector)
}

export function removeElement(el) {
  if (el && el.parentNode) {
    el.parentNode.removeChild(el);
  }
}

export function insertAfter(el, referenceNode) {
    return referenceNode.parentNode.insertBefore(el, referenceNode.nextSibling);
}

export function arrayToSentence(arr) {
  return arr.join(", ").replace(/,\s([^,]+)$/, ' and $1');
}

export function toSentence(str) {
  return str.split("_").map(word => word.charAt(0).toUpperCase() + word.slice(1)).join(" ");
}
