// 1. Variables
const client = algoliasearch("2NKIO6XW2P", "2f9755db01f6fd63288ea4daf832947f");
const index = client.initIndex('Business');
const searchOptions = { hitsPerPage: 10, page: 0 };
const searchInput = "#algolia-search"
let searchQuery = 'Glam'


// 2. Functions
function searchDone(content) {
  console.log(content)
}

function searchFailure(err) {
  console.error(err);
}

function initSearch() {
  index.search(searchQuery, searchOptions)
    .then(content => searchDone(content))
    .catch(err => searchFailure(err));
}


// 3. Event Listeners
