// Extension checks for existing history
// Extension gets history (starting from date in local if available)
// Extension sends history to client
// Client Meteor.calls
// Meteor returns new history item, which replaces the stored local

// Listen for any changes to the URL of any tab.
chrome.tabs.onUpdated.addListener(checkForValidUrl);

function checkForValidUrl(tabId, changeInfo, tab) {
  if (tab.url == "http://localhost:3000/") {
  // if (tab.url == "http://curiosity.meteor.com/") {
    chrome.pageAction.show(tabId); // show the page action

    if (tab.url !== undefined && changeInfo.status == "complete") {
      initVariables();
    }
  }
};


function initVariables(){
  // Check for a locally stored history and if it exists, save it.
  var hasLocal = false;
  var localHistory = {};
  var userID = '';
  chrome.storage.local.get(function(d) {
    if(d.localHistory){ // If we have a history, pull the values that we've saved
      var localHistory = d.localHistory;
      var userID = d.userID;
      var lastVisitTime = d.lastVisitTime;
    }else{ // Otherwise initialize the variables we need
      var localHistory = {};
      var userID = makeID();
      var lastVisitTime = 0;
    }

    sendHistory(lastVisitTime, localHistory, userID);
    
  });
}

function sendHistory(lastVisitTime, localHistory, userID){
  var combinedHistory;
  chrome.history.search({
      'text': 'http://en.wikipedia.org/wiki/*',              // Return every history item....
      'maxResults': 50000,
      'startTime': (lastVisitTime+.1) // Give the .1 as a little buffer to avoid long float comparisons falling the wrong way
    },
    function(historyItems) {
      // console.log(historyItems);
      if(historyItems.length>0){ //i.e. there are new history items
        combinedHistory = historyItems.concat(localHistory);
        lastVisitTime = historyItems[0].lastVisitTime;
      }else{
        combinedHistory = localHistory;
      }

      chrome.storage.local.set({'lastVisitTime': lastVisitTime});
      chrome.storage.local.set({'localHistory': combinedHistory});
      chrome.storage.local.set({'userID': userID});

      console.log("History sent");
      
      // Send a message to the content_script with all of the history items
      chrome.tabs.query({active: true, currentWindow: true}, function(tabs) {
        chrome.tabs.sendMessage(tabs[0].id, {greeting: "wikihistory", payload: combinedHistory, userID:userID}, function(response) {
          console.log(response);
        });
      });
  });
}



chrome.runtime.onMessage.addListener(
  function(request, sender, sendResponse) {
    // console.log(sender.tab ?
    //             "from a content script:" + sender.tab.url :
    //             "from the extension");
    if (request.greeting == "wtf"){
      if(request.payload.length){
        console.log("Received server response");
        // console.log("Got new from server");
        // console.log(request.payload);
        // chrome.storage.local.set({'edges': request.payload});
        // console.log("Just set storage with ID: " + request.userID);
        // chrome.storage.local.set({'userID': request.userID});
        // chrome.storage.local.set({'scrapedIDs': request.scrapedIDs});
        // console.log("Set new localHistory");
        sendResponse({farewell: "goodbye"});
      }
    }
  });



function makeID() {
  var i, possible, text;
  text = "";
  possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
  i = 0;
  while (i < 16) {
    text += possible.charAt(Math.floor(Math.random() * possible.length));
    i++;
  }
  return text;
};



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