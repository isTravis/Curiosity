// Listen for any changes to the URL of any tab.
chrome.tabs.onUpdated.addListener(checkForValidUrl);

function checkForValidUrl(tabId, changeInfo, tab) {
  if (tab.url == "http://blergblerg.meteor.com/") {
    chrome.pageAction.show(tabId); // show the page action

    if (tab.url !== undefined && changeInfo.status == "complete") {
      sendHistory();
    }
  }
};

function sendHistory(){
  chrome.history.search({
      'text': 'http://en.wikipedia.org/wiki/*',              // Return every history item....
      'maxResults': 10000 ,
      'startTime': 0  
    },
    function(historyItems) {
      console.log(historyItems.length);

      // Send a message to the content_script with all of the history items
      chrome.tabs.query({active: true, currentWindow: true}, function(tabs) {
        chrome.tabs.sendMessage(tabs[0].id, {greeting: "hello", payload: historyItems}, function(response) {
          console.log(response);
        });
      });

    });
}






