var wikihistory;

document.getElementById("hasExtension").innerHTML = ""
document.getElementsByClassName("status").className = "status"

chrome.runtime.onMessage.addListener(
  function(request, sender, sendResponse) {
    if (request.greeting == "wikihistory"){
        wikihistory = request.payload;
        userID = request.userID;
        window.postMessage({ type: "FROM_PAGE_WIKI", text: wikihistory, userID:userID }, "*");
        sendResponse({response: "recieved"});
    }else if (request.greeting == "edges"){
        edges = request.payload;
        userID = request.userID;
        scrapedIDs = request.scrapedIDs
        // console.log("gotedgesmessage from ext at script:");
        // console.log(scrapedIDs);
        window.postMessage({ type: "FROM_PAGE_EDGES", text: edges, userID:userID, scrapedIDs:scrapedIDs }, "*");
        sendResponse({response: "recieved"});
    }
    
    // var div = document.getElementById('here');
    // div.innerHTML = div.innerHTML + wikihistory;
  });



window.addEventListener("message", function(event) {
  // We only accept messages from ourselves
  if (event.source != window)
    return;

  if (event.data.type && (event.data.type == "FROM_Server")) {
    myData = event.data.text;
    userID = event.data.userID;
    scrapedIDs = event.data.scrapedIDs;

    // console.log("Received from Server: " + event.data.text);

    // var div = document.getElementById('here');
    // div.innerHTML = div.innerHTML + event.data.text;
    // console.log("inscript ids" + scrapedIDs)

    chrome.runtime.sendMessage({greeting: "wtf", payload: myData, userID:userID, scrapedIDs:scrapedIDs}, function(response) {
      console.log(response.farewell);
    });
  }
}, false);



