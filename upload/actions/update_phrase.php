<?php
require_once dirname(__FILE__, 2) . '/includes/admin_config.php';
global $userquery;
$userquery->admin_login_check();

$id_language_key = $_POST['id_language_key'];
$translation = $_POST['translation'];
$language_id = $_POST['language_id'];

Language::getInstance()->update_phrase($id_language_key, $translation, $language_id);

echo $translation;
