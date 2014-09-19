<!-- File: /app/View/Posts/add.ctp -->

<h1>Add Post</h1>
<?php
$this->Html->script('https://ajax.googleapis.com/ajax/libs/jquery/1.6.4/jquery.min.js', array("inline"=>false));
$this->Html->script('https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.16/jquery-ui.min.js', array("inline"=>false));

$this->Html->script('tinymce/tinymce.min', array("inline"=>false));
$this->Html->script('posts/edit', array("inline"=>false));
$this->Html->script('multiautocomplete/multiautocomplete', array("inline"=>false));

echo $this->Html->css('posts/edit');


$this->Html->scriptStart(array('inline' => false));
?>

tinymce.init({
	selector: "textarea",
	plugins: "code"
});

<?php
$this->Html->scriptEnd();


echo $this->Form->create('Post');
echo $this->Form->input('title');
echo $this->Form->input('body', array('rows' => '3'));
echo $this->Form->end('Save Post');
?>