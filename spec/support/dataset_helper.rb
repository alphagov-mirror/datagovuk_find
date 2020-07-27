INDEX = "datasets-test".freeze

def index(*datasets)
  datasets.each do |dataset, i|
    Elasticsearch::Model.client.index index: INDEX, type: "dataset", id: i, body: dataset.to_json
  end
  refresh_index
end

def refresh_index
  Elasticsearch::Model.client.indices.refresh index: INDEX
end

def index_and_visit(dataset)
  index(dataset)
  visit dataset_path(dataset.uuid, dataset.name)
end

def search_for(query)
  visit "/"
  within "#main-content" do
    fill_in "q", with: query
    find(".gem-c-search__submit").click
  end
end

def filtered_search_for(query, sort_method)
  visit "/search"
  within "#main-content" do
    fill_in "q", with: query
    select sort_method, from: "Sort by"
    find(".gem-c-search__submit").click
  end
end
