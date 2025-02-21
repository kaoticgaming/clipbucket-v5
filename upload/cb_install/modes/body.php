<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>ClipBucket v<?php echo VERSION . ' ' . STATE; ?> Installer</title>
    <link href="style.css" rel="stylesheet" type="text/css"/>
    <link href='//fonts.googleapis.com/css?family=Cabin:regular,bold' rel='stylesheet' type='text/css'/>
    <script type="text/javascript" src="//ajax.googleapis.com/ajax/libs/jquery/1.5.0/jquery.min.js"></script>
    <script type="text/javascript" src="functions.js"></script>
    <link href="bootstrap/css/bootstrap-theme.min.css" rel="stylesheet" type="text/css"/>
    <link href="bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css"/>
</head>
<body>
<div class="top clearfix">
    <div class="top_tabs">
        <ul>
            <li><a href="https://github.com/MacWarrior/clipbucket-v5/issues" target="_blank">Bug Report</a></li>
        </ul>
    </div>
    <p></p> <span id="logo"><span style="color:#09c;">ClipBucketV5</span> Installer v<?php echo VERSION . ' - Revision ' . REV . ' <i>(' . STATE . ')</i>'; ?></span>
    <p></p>
</div>

<div class="top_nav clearfix" style="height:35px;">
    <div class="cb_container">
        <div class="cb_navbar">
            <ul class="headstatus">
                <li <?php echo selected('agreement'); ?>>Agreement</li>
                <li <?php echo selected('precheck'); ?>>Pre Check<span></span></li>
                <li <?php echo selected('permission'); ?>>Permissions<span></span></li>
                <li <?php echo selected('database'); ?>>Database<span></span></li>
                <li <?php echo selected('dataimport'); ?>>Data import<span></span></li>
                <li <?php echo selected('adminsettings'); ?>>Admin Settings<span></span></li>
                <li <?php echo selected('sitesettings'); ?>>Site Settings<span></span></li>
                <li <?php echo selected('finish'); ?>>Finish<span></span></li>
            </ul>
        </div>
    </div>
</div>

<?php
switch ($mode) {
    case 'agreement':
    case 'precheck':
    case 'permission':
    case 'database':
    case 'dataimport':
    case 'adminsettings':
    case 'sitesettings':
    case 'finish':
    case 'lock':
        include_once(__DIR__ . '/' . $mode . '.php');
        break;
    default:
        var_dump($mode);
}
?>
</body>
</html>