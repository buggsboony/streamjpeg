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
            echo "check exists [$potentialFile] :"; var_dump($exists);
            if($exists):
                $lastExistingNum = $num;
            endif;
            $num+=$dico;        
        }while($exists);   
        //not exists, will continue 
    endforeach;
    return $lastExistingNum;
}//dicoFindLatestFile

$lastNumFound = dicoFindLatestFile($pattern,$ext);


?>