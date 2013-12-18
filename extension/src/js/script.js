var wikihistory

chrome.runtime.onMessage.addListener(
  function(request, sender, sendResponse) {
    if (request.greeting == "hello")
      sendResponse({response: "recieved"});

    // console.log (request.payload[0].url);
    wikihistory = request.payload;

    var div = document.getElementById('here');
    console.log (wikihistory);
    div.innerHTML = div.innerHTML + "{"
    for (var i = 0; i<wikihistory.length; i++){
    	div.innerHTML = div.innerHTML + "\"" + i + "\"" + ":["
    	div.innerHTML = div.innerHTML + "\"" + wikihistory[i].id + "\","
    	div.innerHTML = div.innerHTML + "\"" + wikihistory[i].lastVisitTime + "\","
    	div.innerHTML = div.innerHTML + "\"" + wikihistory[i].url + "\","
    	div.innerHTML = div.innerHTML + "\"" + wikihistory[i].visitCount + "\""
    	div.innerHTML = div.innerHTML + "],"

    	// div.innerHTML = div.innerHTML + i + ": " + wikihistory[i].url + "<br>";	
    	// div.innerHTML = div.innerHTML + i + ": " + wikihistory[i].url.match(/[^/]+$/) + "<br>";	
    }
    div.innerHTML = div.innerHTML + "}"
	// div.innerHTML = div.innerHTML + wikihistory
  });
