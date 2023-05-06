<?php
function str_startsWith( $haystack, $needle ) {
	$length = strlen( $needle );
	return substr( $haystack, 0, $length ) === $needle;
}

function str_endsWith( $haystack, $needle ) {
    $length = strlen( $needle );
    if( !$length ) {
        return true;
    }
    return substr( $haystack, -$length ) === $needle;
 }

?>
<html>
<head>
    <title>Streamjpeg - MJPEG SERVER</title>
    <style>
        body {
            background-color: black;
            color:wheat;
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

<?php 



#detectExtension --
$pattern="art";
$ext=@$_REQUEST["ext"];
if(!$ext):
    $ext="png"; //Default is screencast lossless format
endif;

function dicoFindLatestFile($pattern,$ext)
{
    //2023-05-05 22:38:20 - Detect last number of file/frame abailable
    $dicotom = array(1000,100,10,1);
    $lastExistingNum = 1;
    foreach($dicotom as $dico):

        $num=$lastExistingNum; //when not found / not exists

        do
        {
            $potentialFile = $pattern.$num.".".$ext;
            $exists = file_exists($potentialFile);
           // echo "check exists [$potentialFile] :"; var_dump($exists);
            if($exists):
                $lastExistingNum = $num;
            endif;
            $num+=$dico;
        }while($exists);
        //not exists, will continue
    endforeach;
    return $lastExistingNum;
}//dicoFindLatestFile

//2023-05-05 23:08:10 - Not used for now $lastNumFound = dicoFindLatestFile($pattern,$ext);

//2023-05-05 23:08:19 - read and get last number
$lastNumFound = 1;
$lastFileFound = null;
$dir=".";
$files = scandir($dir,SCANDIR_SORT_DESCENDING);
//2023-05-05 23:26:30 - Sort by str length
function sortByLength($a,$b)
{
    return strlen($b)-strlen($a);
}//sortByLength
usort($files,"sortByLength");

foreach($files as $file)
{    
    //File is a frame file
    if( str_startsWith($file,$pattern) && str_endsWith($file,$ext)  )
    {
        $lastFileFound = $file;
        //Extract num from filename
        $right = substr($file,strlen($pattern) );
        $lastNumFound = substr($right,0, strlen($right)-1-strlen($ext) );            
        //echo "<pre>file,num : \n"; var_dump( $file, $lastNumFound ); echo "</pre>";
        break;//No more browse in loop !
    }else
    {
        //echo "no match pattern\n";
    }
}//next file




//echo "<pre>files scanned: \n"; var_dump( $files ); echo "</pre>";
?>
    <!-- <img id="img" alt="streaming test" src="http://0.0.0.0:8080/maryjane/"/> -->
    <div class="btns">
  <!-- 

      <button id="stopBtn" onclick="window.exitLoop=1; closeInterval(window.timer);">STOP</button>
  -->
    </div>
    <img id="img" alt="streaming test" src="<?php echo $pattern;?>"/>

     <script>
 var btn = document.getElementById("stopBtn");
 //btn.innerText="hello"; //2023-05-02 16:09:12 - not working
 //btn.style.color="red";
        //ffmpeg -y -re -stream_loop -1 -i /home/boony/Vidéos/carly.mp4 -f image2 -update 1 /home/boony/Documents/dev/mjpeg_server/art.jpeg

    window.exitLoop=0;
    window.img = document.getElementById("img");
    
    //2023-05-05 23:22:47 - Start with last known number
    <?php echo "var n=$lastNumFound;\n"?>
    // var baseUrl = img.src.split("?")[0]; //Default first time
    // console.log("starting loop, baseUrl="+baseUrl );

    var pattern = "<?php echo $pattern;?>";
    var ext = "<?php echo $ext;?>";
    var baseUrl = pattern+"."+ext;
    console.log("starting loop, baseUrl="+baseUrl );


    var deleteFreq = 31*1000;//Set interval delete
    var freq = 42; // speed (setInterval Freq)
    //2023-05-02 13:19:13 - Not working at all, browser will seriously crash using this function !
    //2023-05-02 13:22:39 - Nécessite un killall brave
    var step=2; //Speed js
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


    function loadNextImgNoExt()
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

    function loadNextImg()
    {
        var newurl = pattern+n+"."+ext;
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
        postData.append('pattern', pattern);
        postData.append('ext', ext);
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
