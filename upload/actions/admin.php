<?php
require_once '../includes/admin_config.php';
global $userquery, $myquery, $cbvid, $eh, $db;
$userquery->admin_login_check();

$mode = $_POST['mode'];
switch ($mode) {
    case 'add_sticky':
        $value = $_POST['note'];
        $myquery->insert_note($value);
        $array['note'] = nl2br($value);
        $array['id'] = $db->insert_id();

        echo json_encode($array);
        break;

    case 'delete_note':
        $id = mysql_clean($_POST['id']);
        $myquery->delete_note($id);
        break;

    case 'delete_comment':
        Comments::delete(['comment_id' => $_POST['cid']]);
        $error = $eh->get_error();
        $warning = $eh->get_warning();
        $message = $eh->get_message();

        if ($error) {
            $err = $error[0]['val'];
        } else {
            if ($warning) {
                $err = $warning[0]['val'];
            }
        }
        if ($message) {
            $msg = $message[0]['val'];
        }

        $ajax['msg'] = $msg;
        $ajax['err'] = $err;

        echo json_encode($ajax);
        break;

    case 'spam_comment':
        $rating = Comments::setSpam($_POST['cid']);
        $error = $eh->get_error();
        $warning = $eh->get_warning();
        $message = $eh->get_message();

        if ($error) {
            $err = $error[0]['val'];
        } else {
            if ($warning) {
                $err = $warning[0]['val'];
            }
        }
        if ($message) {
            $msg = $message[0]['val'];
        }

        $ajax['msg'] = $msg;
        $ajax['err'] = $err;

        echo json_encode($ajax);
        break;

    case 'remove_spam':
        Comments::unsetSpam($_POST['cid']);
        $error = $eh->get_error();
        $warning = $eh->get_warning();
        $message = $eh->get_message();

        if ($error) {
            $err = $error[0]['val'];
        } else {
            if ($warning) {
                $err = $warning[0]['val'];
            }
        }
        if ($message) {
            $msg = $message[0]['val'];
        }

        $ajax['msg'] = $msg;
        $ajax['err'] = $err;

        echo json_encode($ajax);
        break;
}
