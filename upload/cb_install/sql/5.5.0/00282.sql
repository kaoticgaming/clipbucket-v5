SET @language_id_fra = (SELECT `language_id` FROM `{tbl_prefix}languages` WHERE language_code = 'fr');

SET @language_key = 'this_already_exist_in_pl' COLLATE utf8mb4_unicode_520_ci;
SET @id_language_key = (SELECT id_language_key FROM `{tbl_prefix}languages_keys` WHERE `language_key` COLLATE utf8mb4_unicode_520_ci = @language_key);

UPDATE `{tbl_prefix}languages_translations`
    SET `translation` = 'Cette %s existe déjà dans votre playlist'
    WHERE `id_language_key` = @id_language_key AND `language_id` = @language_id_fra;
