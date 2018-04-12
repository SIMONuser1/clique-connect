AlgoliaSearch.configuration = {
  application_id: SECRET["development"]["algolia_app_id"],
  api_key: SECRET["development"]["algolia_api_key"],
  connect_timeout: 2,
  receive_timeout: 30,
  send_timeout: 30,
  batch_timeout: 120,
  search_timeout: 5
}
