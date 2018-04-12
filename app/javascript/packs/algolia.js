import $ from 'jquery';

// 1. Variables
const client = algoliasearch("2NKIO6XW2P", "2f9755db01f6fd63288ea4daf832947f");
const index = client.initIndex('Business');
const searchOptions = { hitsPerPage: 10, page: 0 };
const searchInput = document.querySelector("#algolia-search")


// 2. Functions

function buildResults(r) {
  console.log(r.name)
}

function searchDone(content) {
  const results = content.hits;
  // console.log(results);
  // results.forEach(r => buildResults(r))

  searchInput.autocomplete({ hint: false }, [
    {
      source: $.fn.autocomplete.sources.hits(index, { hitsPerPage: 5 }),
      displayKey: 'my_attribute',
      templates: {
        suggestion: function(suggestion) {
          return suggestion._highlightResult.my_attribute.value;
        }
      }
    }
  ]).on('autocomplete:selected', function(event, suggestion, dataset) {
    console.log(suggestion, dataset);
  });

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




