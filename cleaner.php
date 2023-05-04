<?php
#2023-05-04 11:34:42 - Clean older file (by num analysis)

 //2023-04-25 09:12:42 - Delete if exists
 function unlinkIfExists($filename)
 {
	 if(file_exists($filename) )
	 {
		  unlink($filename);
		  return true;
	 }
	 return false;
 }
 


$dir = ".";
$pattern = "art";
$n = @$_REQUEST["n"];
$pattern = @$_REQUEST["pattern"];
$ext = @$_REQUEST["ext"];

$deleteds = array(); //store success list

echo "<pre>_request: \n"; var_dump( $_REQUEST ); echo "</pre>";

echo "<pre>number n=: \n"; var_dump( $n ); echo "</pre>";
if( $n ):
    
    //2023-05-04 11:51:05 - Delete all above
    $deleted = "start loop";
    while($deleted):
        $filename = $pattern.$n.".".$ext;
        $deleted = unlinkIfExists($filename); //false when not found
        //echo "<pre>unlinkIfExists($filename): \n"; var_dump( $deleted ); echo "</pre>";
        if($deleted) {
            $deleteds[] = $filename;
        }
        else
        {
            echo "<pre>Fail to delete $filename : \n"; var_dump( $deleted ); echo "</pre>";            
        }
        $n--;
    endwhile;
    echo "<pre>deleted list: \n"; var_dump( $deleteds ); echo "</pre>";
    echo "<pre>end, exit loop !\n"; echo "</pre>";
endif;



?>