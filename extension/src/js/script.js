var wikihistory;

chrome.runtime.onMessage.addListener(
  function(request, sender, sendResponse) {
    if (request.greeting == "hello")
        wikihistory = request.payload;
        window.postMessage({ type: "FROM_PAGE", text: wikihistory }, "*");
        sendResponse({response: "recieved"});

    // console.log (request.payload[0].url);
    

    // var div = document.getElementById('here');
    // console.log (wikihistory);
    // div.innerHTML = div.innerHTML + "{"
    // for (var i = 0; i<wikihistory.length; i++){
    // 	div.innerHTML = div.innerHTML + "\"" + i + "\"" + ":["
    // 	div.innerHTML = div.innerHTML + "\"" + wikihistory[i].id + "\","
    // 	div.innerHTML = div.innerHTML + "\"" + wikihistory[i].lastVisitTime + "\","
    // 	div.innerHTML = div.innerHTML + "\"" + wikihistory[i].url + "\","
    // 	div.innerHTML = div.innerHTML + "\"" + wikihistory[i].visitCount + "\""
    // 	div.innerHTML = div.innerHTML + "],"

    // 	// div.innerHTML = div.innerHTML + i + ": " + wikihistory[i].url + "<br>";	
    // 	// div.innerHTML = div.innerHTML + i + ": " + wikihistory[i].url.match(/[^/]+$/) + "<br>";	
    // }
    // div.innerHTML = div.innerHTML + "}"
	// div.innerHTML = div.innerHTML + wikihistory
  });



window.addEventListener("message", function(event) {
  // We only accept messages from ourselves
  if (event.source != window)
    return;

  if (event.data.type && (event.data.type == "FROM_Server")) {
    myData = event.data.text
    console.log("Received from Server: " + event.data.text);
    chrome.runtime.sendMessage({greeting: "wtf", payload: myData}, function(response) {
      console.log(response.farewell);
    });
  }
}, false);


// var urls = [a,b,c,d],

// var unvisitedUrls = [],
//     count = urls.length,
//     done = false;

// var checkUrl = function(d) {
//   var url = d;


//   return function(visitItems) {
//     console.log(visitItems);
//     if (done) return;
//     count--;

//     if (visitItems && visitItems.length > 0) {
//         unvisitedUrls.push(url);
//     }
//     else {
//         urls.splice(urls.indexOf(url));  // remove the visited url
//     }

//     if(unvisitedUrls.indexOf(urls[0]) > -1 || count === 0) {
//         done = true;
//         // done checking urls, urls[0] is the winner
//     }

//   }
// }


// urls.forEach(function(d) { chrome.history.getVisits({'url':d}, checkUrl(d)); });


// chrome.history.search({'text': '','maxResults': N ,'startTime': 0},function(historyItems) {
//       console.log(historyItems);
//     });


//       // Send a message to the content_script with all of the history items
//       // chrome.tabs.query({active: true, currentWindow: true}, function(tabs) {
//       //   chrome.tabs.sendMessage(tabs[0].id, {greeting: "hello", payload: historyItems}, function(response) {
//       //     console.log(response);
//       //   });
//       // });

//     });