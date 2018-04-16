import $ from 'jquery';

// 1. Variables
const client = algoliasearch("2NKIO6XW2P", "2f9755db01f6fd63288ea4daf832947f");
const index = client.initIndex('Business');
const searchOptions = { hitsPerPage: 10, page: 0 };

const navbar = document.querySelector(".bg-dark.navbar-dark");
const searchInput = document.querySelector("#algolia-search");
const resultContainer = document.querySelector("#search-results-container");
const resultList = resultContainer.querySelector(".list-group");


// 2. Functions
function buildResultList(r) {
  const loc = window.location
  const link = loc.protocol + "//" + loc.host + '/businesses/' + `${r.objectID}`
  const HTML = `<a href="${link}" class="list-group-item list-group-item-action">${r.name}</a>`
  resultList.insertAdjacentHTML("beforeend", HTML)
}

function clearResultList() {
  resultList.innerHTML = "";
}

function getNavPos() {
  const searchPos = searchInput.getBoundingClientRect();
  const navPos = navbar.getBoundingClientRect();

  // object to set result list fixed position
  return {
    top: navPos.bottom,
    right: (window.innerWidth - searchPos.width - searchPos.left),
    left: searchPos.left
  }
}

function computeResultPos(p) {
  resultContainer.style.setProperty('top', `${p.top + 1}px`);
  resultContainer.style.setProperty('left', `${p.left}px`);
  resultContainer.style.setProperty('right', `${p.right}px`);
}

function updateResultPos() {
  const pos = getNavPos();
  computeResultPos(pos);
  console.log(pos);
}

// Algolia methods
function searchDone(content) {
  const results = content.hits;
  console.log(results);
  results.forEach(r => buildResultList(r))

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
  const searchQuery = e.target.value;

  if (searchQuery.length > 3) {
    clearResultList();
    updateResultPos();
    initSearch(searchQuery);
  }
})

searchInput.addEventListener("blur", clearResultList);

searchInput.addEventListener("focus", (e) => {
  const searchQuery = e.target.value;

  if (searchQuery.length > 3) {
    initSearch(searchQuery);
  }
});

window.addEventListener('resize', updateResultPos)

