//add a class of js to the body tag for CSS purposes
document.getElementsByTagName('html')[0].className += ' js';
 
//read cookies
function readCookie(name){
    var cookieName = name + "=";
    var ca = document.cookie.split(';');
    for (var i = 0; i < ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0) == ' ')
            c = c.substring(1, c.length);
        if (c.indexOf(cookieName) == 0)
            return c.substring(cookieName.length, c.length);
    }
    return null;
};
 
//we check for when the DOM has loaded and if the user has not closed our Information Bar
document.onreadystatechange = function(){
    if (document.readyState == "complete" && !readCookie('refuseChromeInstall')) {
        CFInstall.check({
            //disable the default prompting mechanism
            preventPrompt: true,
 
            //if Google Chrome Frame is missing we execute the folowing function
            onmissing: function(){
                //create the Information Bar
                var updateBar = document.createElement('div');
                updateBar.id = 'updateBar';
 
                updateBar.onmouseover = function(){
                    this.className = 'over';
                };
                updateBar.onmouseout = function(){
                    this.className = '';
                };
 
                //when the user clicks on the Information Bar, open a popup with the Google Chrome Frame terms of service page
                updateBar.onclick = function(){
                    window.open('http://www.google.com/chromeframe/eula.html', 'GCFInstall', 'width=760, height=500');
                };
 
                var updateMessage = document.createElement('div');
                updateMessage.id = 'updateMessage';
                updateMessage.appendChild(document.createTextNode('Internet Explorer is missing updates required to view this site. Click here to update...'));
                updateBar.appendChild(updateMessage);
 
                var closeUpdateBar = document.createElement('div');
                closeUpdateBar.id = 'closeUpdateBar';
                closeUpdateBar.onclick = function(){
                    //if the user chooses not to install Google Chrome Frame, we set a cookie, so as not to show the Information Bar on every page refresh
                    document.cookie = 'refuseChromeInstall=1';
 
                    //remove the Information Bar
                    document.getElementsByTagName('body')[0].removeChild(document.getElementById('updateBar'));
                };
 
                //append the close button to our Information Bar
                updateBar.appendChild(closeUpdateBar);
 
                //append the Information Bar to our body element
                document.getElementsByTagName('body')[0].appendChild(updateBar);
            }
        });
    }
};
