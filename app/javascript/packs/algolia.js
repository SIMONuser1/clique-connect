import $ from 'jquery';

// 1. Variables
const client = algoliasearch("2NKIO6XW2P", "2f9755db01f6fd63288ea4daf832947f");
const index = client.initIndex('Business');
const searchOptions = { hitsPerPage: 10, page: 0 };
const searchInput = document.querySelector("#algolia-search")
const searchResults = document.querySelector("#search-results-list")


// 2. Functions

function buildResults(r) {
  const item = `<a href="#" class="list-group-item list-group-item-action">${r.name}</a>`
  // `<li class="list-group-item">${r.name}</li>`
  searchResults.insertAdjacentHTML("beforeend", item)
}

function clearResults() {
  searchResults.innerHTML = "";
}

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


// 3. Event Listeners
searchInput.addEventListener("keyup", (e) => {
  let searchQuery = e.target.value;

  if (searchQuery.length > 3) {
    initSearch(searchQuery);
  }
})

searchInput.addEventListener("blur", clearResults);

searchInput.addEventListener("focus", (e) => {
  let searchQuery = e.target.value;

  if (searchQuery.length > 3) {
    initSearch(searchQuery);
  }
});




