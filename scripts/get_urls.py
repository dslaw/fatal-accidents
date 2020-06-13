from lxml import html
import json
import requests


def find_links(url):
    response = requests.get(url, timeout=30)
    root = html.fromstring(response.text)
    content, *_ = root.find_class("content")
    return content.xpath("table/tbody//a")


links = {}
directory_url = "https://www.nhtsa.gov/node/97996/251"
directory_links = find_links(directory_url)
for link in directory_links:
    try:
        year = int(link.text)
    except ValueError:
        pass
    else:
        links[year] = [{
            "text": link.text,
            "href": link.attrib["href"],
        }]

for path in links.values():
    url = path[-1]["href"]
    country_links = find_links(url)
    for link in country_links:
        if link.text == "National":
            path.append({
                "text": link.text,
                "href": link.attrib["href"],
            })


for path in links.values():
    url = path[-1]["href"]
    download_links = find_links(url)
    for link in download_links:
        if "CSV" in link.text and link.text.endswith(".zip"):
            path.append({
                "text": link.text,
                "href": link.attrib["href"],
            })


sorted_links = {year: links[year] for year in sorted(links)}
with open("src/resources/dataset_urls.json", "w") as fh:
    json.dump(sorted_links, fh, indent=2)
