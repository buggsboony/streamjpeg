<html>
<head>
    <title>Streamjpeg - MJPEG SERVER</title>
    <style>
        body {
            background-color: black;
        }
        img {
            max-width: 100%;
        }
        button{
            width:200px;
            height: 130px;
            background-color: bisque;
            color:cadetblue;
            font-size: 2em;
        }
        .btns
        {
            margin-bottom: 4px;
        }
    </style>
</head>
<body>
    <!-- <img id="img" alt="streaming test" src="http://0.0.0.0:8080/maryjane/"/> -->
    <div class="btns">
  <!-- 

      <button id="stopBtn" onclick="window.exitLoop=1; closeInterval(window.timer);">STOP</button>
  -->
    </div>
    <img id="img" alt="streaming test" src="art"/>

     <script>
 var btn = document.getElementById("stopBtn");
 //btn.innerText="hello"; //2023-05-02 16:09:12 - not working
 //btn.style.color="red";
        //ffmpeg -y -re -stream_loop -1 -i /home/boony/Vidéos/carly.mp4 -f image2 -update 1 /home/boony/Documents/dev/mjpeg_server/art.jpeg

    window.exitLoop=0;
    window.img = document.getElementById("img");
    var n = 0;
    var baseUrl = img.src.split("?")[0]; //Prendre le début pour la premiere fois.
    console.log("starting loop, baseUrl="+baseUrl );


    var deleteFreq = 31*1000;//Set interval delete
    var freq = 42; // speed (setInterval Freq)
    //2023-05-02 13:19:13 - Not working at all, browser will seriously crash using this function !
    //2023-05-02 13:22:39 - Nécessite un killall brave
    var step=1; //Speed js
    var k=0;  //private var to make inc_freq work
    var inc_freq=1; //Every inc_freq, image will increment
    function loop_deprecated() 
    {        
        
        while(!window.exitLoop)
        {
            var newurl = baseUrl+"?v="+n;
            window.img.src=newurl;
            n+=step;
            if(n>=MAX_FRAME_RESET)n=0;
            console.log(newurl);
        }//wend
    }

    window.MAX_FRAME_RESET=9999999;


    function reloadSameImg()
    {        
            var newurl = baseUrl+"?v="+n;
            window.img.src=newurl;
            n+=step;
            if(n>=MAX_FRAME_RESET)n=0;
            console.log(newurl);
    
    }//reloadSameImg

    function loadNextImg()
    {
        var newurl = baseUrl+n;
            window.img.src=newurl;
            if(k>=inc_freq)    
            {
                k=0;
                n+=step;  
            }
            k++;    
            console.log("step="+step,newurl);
    }//loadNextImg


    //2023-05-04 12:37:41 - Ajax request to delete all images above current the read one
    function deleteAbove()
    {
        console.log("%c deleteAbove "+n,"color:orange");
        var url = "cleaner.php";
        var postData = new FormData();
        postData.append('n', n);
               var xhttp = new XMLHttpRequest();
               xhttp.onreadystatechange = function() {
                   if (this.readyState == 4 && this.status == 200) {
                    // Typical action to be performed when the document is ready:
                    console.log("cleaner response:");
                    console.log(this.responseText);                    
                   }
               };          
       xhttp.open("POST", url, true);
       xhttp.send(postData);
    }//deleteAbove

    window.timerId = setInterval( loadNextImg,freq);
    window.deleteTimerId = setInterval( deleteAbove,deleteFreq);
    //loop();
     </script>
</body>
</html>
