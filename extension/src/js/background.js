// Extension checks for existing history
// Extension gets history (starting from date in local if available)
// Extension sends history to client
// Client Meteor.calls
// Meteor returns new history item, which replaces the stored local

// Listen for any changes to the URL of any tab.
chrome.tabs.onUpdated.addListener(checkForValidUrl);

function checkForValidUrl(tabId, changeInfo, tab) {
  if (tab.url == "http://localhost:3000/") {
    chrome.pageAction.show(tabId); // show the page action

    if (tab.url !== undefined && changeInfo.status == "complete") {
      checkAndSendHistory();
    }
  }
};


function checkAndSendHistory(){
  // Check for a locally stored history and if it exists, save it.
  var hasLocal = false
  var localHistory = {}
  chrome.storage.local.get('localHistory', function(d) {
    if(d.localHistory){
      localHistory = d.localHistory;
      hasLocal  = true;
      console.log("Local History Available");
    }
    if(hasLocal == true){
      var startTime = 0; // XXX set to be the last value in the local history
    }else{
      var startTime = 0;
    }
    sendNewHistory(startTime);
  });
}

function sendNewHistory(startTime){
  chrome.history.search({
      'text': 'http://en.wikipedia.org/wiki/*',              // Return every history item....
      'maxResults': 200 ,
      'startTime': startTime
    },
    function(historyItems) {
      console.log("SentHistory");
      // Send a message to the content_script with all of the history items
      chrome.tabs.query({active: true, currentWindow: true}, function(tabs) {
        chrome.tabs.sendMessage(tabs[0].id, {greeting: "hello", payload: historyItems}, function(response) {
          console.log(response);
        });
      });

    });

}
// var brackets = 0;
// var notbrackets = 0;
// xx.forEach(function(e) {
//         // console.log("-------");
//         // console.log(e);
//         // xx.push(e.url);
//         chrome.history.getVisits({'url':e}, function(d){
//           if(d.length == 0){
//             brackets += 1;
//           }else{
//             notbrackets += 1;
//           }
//           // console.log(d);
//         })
//       });

chrome.runtime.onMessage.addListener(
  function(request, sender, sendResponse) {
    console.log(sender.tab ?
                "from a content script:" + sender.tab.url :
                "from the extension");
    if (request.greeting == "wtf"){
      console.log("Got new from server");
      console.log(request.payload);
      chrome.storage.local.set({'localHistory': request.payload});
      console.log("Set new localHistory");
      sendResponse({farewell: "goodbye"});
    }
  });



// chrome.storate.local.getBytesInUse(function(d)
  // chrome.storage.local.getBytesInUse( function(d) {
  //   // Notify that we saved.
  //   console.log("I got: ");
  //   console.log(d);
  // });

  //   chrome.storage.local.get('value', function(d) {
  //   // Notify that we saved.
  //   console.log("I got: ");
  //   console.log(d);
  // });

  //       chrome.storage.sync.get(function(d) {
  //   // Notify that we saved.
  //   console.log("I got: ");
  //   console.log(d);
  // });