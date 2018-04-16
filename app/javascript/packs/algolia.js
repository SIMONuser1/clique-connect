import $ from 'jquery';

// 1. Variables
const client = algoliasearch("2NKIO6XW2P", "2f9755db01f6fd63288ea4daf832947f");
const index = client.initIndex('Business');
const searchOptions = { hitsPerPage: 10, page: 0 };
const searchInput = document.querySelector("#algolia-search");
const resultContainer = document.querySelector("#search-results-container");
const resultList = resultContainer.querySelector(".list-group");


// 2. Functions

function buildResults(r) {
  const item = `<a href="#" class="list-group-item list-group-item-action">${r.name}</a>`
  // `<li class="list-group-item">${r.name}</li>`
  resultList.insertAdjacentHTML("beforeend", item)
}

function clearResults() {
  resultList.innerHTML = "";
}

function computeNavPosition() {
  const pos = searchInput.getBoundingClientRect();
  return {
    bottom: pos.bottom,
    right: (window.innerWidth - pos.width - pos.left),
    left: pos.left
  }
}

function updateResultPotition(p) {
  resultContainer.style.setProperty('top', `${p.bottom + 10}px`);
  resultContainer.style.setProperty('left', `${p.left}px`);
  resultContainer.style.setProperty('right', `${p.right}px`);
  resultContainer.style.setProperty('height', '20px');
  resultContainer.style.setProperty('background', 'red')
}

// Algolia methods
function searchDone(content) {
  const results = content.hits;
  console.log(results);
  clearResults()
  results.forEach(r => buildResults(r))

}

function searchFailure(err) {
  console.error(err);
}

function initSearch(q) {
  index.search(q, searchOptions)
    .then(content => searchDone(content))
    .catch(err => searchFailure(err));
}
// Algolia methods (End)



// 3. Event Listeners
searchInput.addEventListener("keyup", (e) => {
  let searchQuery = e.target.value;
  let pos = computeNavPosition();
  updateResultPotition(pos);

  if (searchQuery.length > 3) {
    initSearch(searchQuery);
  }

  console.log(pos);
})

searchInput.addEventListener("blur", clearResults);

searchInput.addEventListener("focus", (e) => {
  let searchQuery = e.target.value;

  if (searchQuery.length > 3) {
    initSearch(searchQuery);
  }
});


