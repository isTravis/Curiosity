// Listen for any changes to the URL of any tab.
chrome.tabs.onUpdated.addListener(checkForValidUrl);

function checkForValidUrl(tabId, changeInfo, tab) {
  if (tab.url == "http://localhost:3000/") {
    chrome.pageAction.show(tabId); // show the page action

    if (tab.url !== undefined && changeInfo.status == "complete") {
      checkAndSendHistory();
      // sendHistory();
      // saveChanges();
    }
  }
};


// Extension checks for existing history
// Extension gets history (starting from date in local if available)
// Extension sends history to client
// Client Meteor.calls
// Meteor returns new history item, which replaces the stored local
// 

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
  });

  if(hasLocal){
    var startTime = 5; // XXX set to be the last value in the local history
  }else{
    var startTime = 0;
  }
  sendNewHistory(startTime);



}


// function saveChanges() {
//   // Get a value saved in a form.
//   // Save it using the Chrome extension storage API.
//   chrome.storage.sync.set({'value': 'tboneee'}, function() {
//     // Notify that we saved.
//     console.log('Settings saved');
//   });

//   chrome.storage.sync.get('value', function(d) {
//     // Notify that we saved.
//     console.log("I got: ");
//     console.log(d);
//   });
// }



function sendNewHistory(startTime){
  chrome.history.search({
      'text': 'http://en.wikipedia.org/wiki/*',              // Return every history item....
      'maxResults': 10 ,
      'startTime': startTime
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






// chrome.storate.local.getBytesInUse(function(d)
//   chrome.storage.local.getBytesInUse( function(d) {
//     // Notify that we saved.
//     console.log("I got: ");
//     console.log(d);
//   });

  //   chrome.storage.sync.get('value', function(d) {
  //   // Notify that we saved.
  //   console.log("I got: ");
  //   console.log(d);
  // });

  //       chrome.storage.sync.get(function(d) {
  //   // Notify that we saved.
  //   console.log("I got: ");
  //   console.log(d);
  // });