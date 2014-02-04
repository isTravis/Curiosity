// Extension checks for existing history
// Extension gets history (starting from date in local if available)
// Extension sends history to client
// Client Meteor.calls
// Meteor returns new history item, which replaces the stored local

// Listen for any changes to the URL of any tab.
chrome.tabs.onUpdated.addListener(checkForValidUrl);

function checkForValidUrl(tabId, changeInfo, tab) {
  if (tab.url == "http://curiosity.meteor.com/") {
  // if (tab.url == "http://curiosity.meteor.com/") {
    chrome.pageAction.show(tabId); // show the page action

    if (tab.url !== undefined && changeInfo.status == "complete") {
      checkAndSendHistory();
    }
  }
};


function checkAndSendHistory(){
  // Check for a locally stored history and if it exists, save it.
  var hasLocal = false;
  var localHistory = {};
  var userID = '';
  chrome.storage.local.get(function(d) {
    if(d.localHistory){
      localHistory = d.localHistory;
      hasLocal  = true;
      console.log("Local History Available");
    }
    if(hasLocal == true){
      var startTime = d.lastVisitTime; // XXX set to be the last value in the local history
      // console.log("last" + d.lastVisitTime);
      userID = d.userID
      sendNewHistory(startTime, localHistory, userID);
    }else{
      var startTime = 0;
      sendNewHistory(startTime, [], userID);
    }
    
  });
}

// Can add a line, so that if there is no new history, you don't ping hte server, just send the stored edges

function sendNewHistory(startTime, localHistory, userID){
  var numRequestsOutstanding = 0;
  chrome.history.search({
      'text': 'http://en.wikipedia.org/wiki/*',              // Return every history item....
      'maxResults': 500,
      'startTime': (startTime+.1) // Give the .1 as a little buffer to avoid long float comparisons falling the wrong way
    },
    function(historyItems) {
      console.log(historyItems);
      if(historyItems.length>0){ //i.e. there are new history items
        console.log("inhere");
        console.log(startTime);
        chrome.storage.local.set({'lastVisitTime': historyItems[0].lastVisitTime});
        chrome.storage.local.set({'localHistory': historyItems.concat(localHistory)});
        console.log("SentHistory");
        // Send a message to the content_script with all of the history items
        chrome.tabs.query({active: true, currentWindow: true}, function(tabs) {
          chrome.tabs.sendMessage(tabs[0].id, {greeting: "wikihistory", payload: historyItems.concat(localHistory), userID:userID}, function(response) {
            console.log(response);
          });
        });
      }else{
        console.log("SentEdges");
        chrome.storage.local.get(function(d) {
          if(d.edges){
            // console.log("scrapedinext " + d.scrapedIDs);
            chrome.tabs.query({active: true, currentWindow: true}, function(tabs) {
              chrome.tabs.sendMessage(tabs[0].id, {greeting: "edges", payload: d.edges, userID: userID, scrapedIDs:d.scrapedIDs}, function(response) {
                console.log(response);
              });
            });
          }else{
            chrome.tabs.query({active: true, currentWindow: true}, function(tabs) {
              chrome.tabs.sendMessage(tabs[0].id, {greeting: "hello", warning: "noWikiHistory"}, function(response) {
                console.log(response);
              });
            });
          }
        });
        
      }
        // Send a message to the content_script with all of the history items
        // chrome.tabs.query({active: true, currentWindow: true}, function(tabs) {
        //   chrome.tabs.sendMessage(tabs[0].id, {greeting: "hello", payload: localHistory}, function(response) {
        //     console.log(response);
        //   });
        // });
    
  });

}


chrome.runtime.onMessage.addListener(
  function(request, sender, sendResponse) {
    console.log(sender.tab ?
                "from a content script:" + sender.tab.url :
                "from the extension");
    if (request.greeting == "wtf"){
      if(request.payload.length){
        console.log("Got new from server");
        // console.log(request.payload);
        chrome.storage.local.set({'edges': request.payload});
        console.log("Just set storage with ID: " + request.userID);
        chrome.storage.local.set({'userID': request.userID});
        chrome.storage.local.set({'scrapedIDs': request.scrapedIDs});
        console.log("Set new localHistory");
        sendResponse({farewell: "goodbye"});
      }
    }
  });


// chrome.storage.local.clear()



// chrome.storate.local.getBytesInUse(function(d)
  // chrome.storage.local.getBytesInUse( function(d) {
  //   // Notify that we saved.
  //   console.log("I got: ");
  //   console.log(d);
  // });

  //   chrome.storage.local.get(function(d) {
  //   // Notify that we saved.
  //   console.log("I got: ");
  //   console.log(d);
  // });

  //       chrome.storage.sync.get(function(d) {
  //   // Notify that we saved.
  //   console.log("I got: ");
  //   console.log(d);
  // });