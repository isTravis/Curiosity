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



// function buildTypedUrlList(divName) {
//   // chrome.history.search({
//   //     'text': '',              // Return every history item....
//   //     'startTime': oneWeekAgo  // that was accessed less than one week ago.
//   //   },
//     function(historyItems) {
//       // For each history item, get details on all visits.
//       for (var i = 0; i < historyItems.length; ++i) {
//         var url = historyItems[i].url;
//         var processVisitsWithUrl = function(url) {
//           // We need the url of the visited item to process the visit.
//           // Use a closure to bind the  url into the callback's args.
//           return function(visitItems) {
//             processVisits(url, visitItems);
//           };
//         };
//         chrome.history.getVisits({url: url}, processVisitsWithUrl(url));
//         numRequestsOutstanding++;
//       }
//       if (!numRequestsOutstanding) {
//         onAllVisitsProcessed();
//       }
//     };



//   // Maps URLs to a count of the number of times the user typed that URL into
//   // the omnibox.
//   var urlToCount = {};

//   // Callback for chrome.history.getVisits().  Counts the number of
//   // times a user visited a URL by typing the address.
//   var processVisits = function(url, visitItems) {
//     for (var i = 0, ie = visitItems.length; i < ie; ++i) {
//       // Ignore items unless the user typed the URL.
//       if (visitItems[i].transition != 'typed') {
//         continue;
//       }

//       if (!urlToCount[url]) {
//         urlToCount[url] = 0;
//       }

//       urlToCount[url]++;
//     }

//     // If this is the final outstanding call to processVisits(),
//     // then we have the final results.  Use them to build the list
//     // of URLs to show in the popup.
//     if (!--numRequestsOutstanding) {
//       onAllVisitsProcessed();
//     }
//   };

//   // This function is called when we have the final list of URls to display.
//   var onAllVisitsProcessed = function() {
//     // Get the top scorring urls.
//     urlArray = [];
//     for (var url in urlToCount) {
//       urlArray.push(url);
//     }

//     // Sort the URLs by the number of times the user typed them.
//     urlArray.sort(function(a, b) {
//       return urlToCount[b] - urlToCount[a];
//     });

//     buildPopupDom(divName, urlArray.slice(0, 10));
//   };
// }


function sendNewHistory(startTime){
  var numRequestsOutstanding = 0;
  chrome.history.search({
      'text': 'http://en.wikipedia.org/wiki/*',              // Return every history item....
      'maxResults': 1000,
      'startTime': startTime
    },
    function(historyItems) {
      // For each history item, get details on all visits.
    //   console.log(historyItems.length);
    //   for (var i = 0; i < historyItems.length; ++i) {
    //     var url = historyItems[i].url;

    //     var processVisitsWithUrl = function(url) {
    //       // We need the url of the visited item to process the visit.
    //       // Use a closure to bind the  url into the callback's args.
    //       return function(visitItems) {
    //         processVisits(url, visitItems);
    //       };
    //     };
    //     chrome.history.getVisits({url: url}, processVisitsWithUrl(url));
    //     numRequestsOutstanding++;
    //     // console.log(numRequestsOutstanding);
    //   }
    //   if (!numRequestsOutstanding) {
    //     onAllVisitsProcessed();
    //   }
    // });

    // var properHistory = {};

    // var processVisits = function(url, visitItems) {
    //   if(visitItems.length >0){
    //       console.log("here");
    //     }
    //   for (var i = 0, ie = visitItems.length; i < ie; ++i) {
    //     // Ignore items unless the user typed the URL.
        
    //     // if (visitItems[i].transition != 'typed') {
    //     //   continue;
    //     // }

    //     if (!properHistory[url]) {
    //       properHistory[url] = {url:url,title:'blah',visits:[]};
    //     }

    //     properHistory[url]['visits'].push(visitItems[i].visitTime);
    //   }

    //   // If this is the final outstanding call to processVisits(),
    //   // then we have the final results.  Use them to build the list
    //   // of URLs to show in the popup.
    //   if (!--numRequestsOutstanding) {
    //     onAllVisitsProcessed();
    //   }
    // };

    // // This function is called when we have the final list of URls to display.
    // var onAllVisitsProcessed = function() {
    //   console.log(properHistory);
    //   // Get the top scorring urls.
    //   // urlArray = [];
    //   // for (var url in prop) {
    //   //   urlArray.push(url);
    //   // }

    //   // // Sort the URLs by the number of times the user typed them.
    //   // urlArray.sort(function(a, b) {
    //   //   return urlToCount[b] - urlToCount[a];
    //   // });

    //   // buildPopupDom(divName, urlArray.slice(0, 10));
    // };




    // function(historyItems) {
    //   var histories = [];
    //   var visits = [];
    //   var historycount = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    //   var visitcount = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    //   var go = 1;
    //   // console.log(historyItems);
    //   var historiesProcessed = 0;
    //         // for(var ii = 0; ii < historyItems.length; ii++)
    //         // {
    //         var ii = 0;
    //         while (go == 1){
    //             historycount[historyItems[ii].visitCount] += 1;
    //             histories.push(historyItems[ii]);
    //             var urll = historyItems[ii].url
    //             console.log(urll);
    //             chrome.history.getVisits({url: historyItems[ii].url}, function(visitItems)
    //             { 

                    
    //                 console.log(visitItems.length);
    //                 // console.log(visitcount[parseInt(visitItems.length)]);
    //                 visitcount[parseInt(visitItems.length)] += 1;
    //                 // console.log('----------------');
    //                 for(var i = 0; i < visitItems.length; i++)
    //                 {
    //                     visits.push(visitItems[i]);
    //                 }
    //                 historiesProcessed++;

    //                 if(historiesProcessed === historyItems.length)
    //                 {
    //                     // console.log(visits);
    //                     go = 0;
    //                 }
    //                 ii += 1;

    //             });
    //             // while( go == 1){console.log('shit');}
    //         }
    //         // console.log(histories.length + ' histories');
    //         console.log(histories);
    //         console.log(visits);




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