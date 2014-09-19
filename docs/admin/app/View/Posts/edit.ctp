<!-- File: /app/View/Posts/edit.ctp -->

<h1>Edit Post</h1>
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

// Allow an empty date if not ready to publish
echo $this->Form->input('publishAt', array('allowEmpty' => true, 'default' => 0, 'empty' => true));

/* Multi select */
//echo $this->Form->input('Category');

//echo "<pre>";
//print_r($categories);
//print_r($categoriesSelected);

//echo "</pre>";
?>


<div class="input select" id="select_categories">
Categories<br>
<ul class="item-list categories">
<?php

/*
echo "<pre>";
print_r($categoriesSelected);
echo "</pre>";
*/

// Loop through each category
foreach ($categories AS $categoryId=>$categoryName)
	{
		// If this category is in the array of categories already associated with this post (in the categories_posts table), then set class=active to show the category. Otherwise the category stays hidden and isn't selected
		if (in_array($categoryId,$categoriesSelected))
		{
			$selected = "class='active'";
		}
		else
		{
			$selected = "";
		}

		// Create each category in a list, but only display if class=active is set
		echo '<li item="' . $categoryId. '" title="' . $categoryName . '"' . $selected . '>' . $categoryName;;
			
		// Allow removal of an active category
		echo '<a class="close" title="Remove ' .  $categoryName . '">x</a>';
		echo '</li>';
	}

	// This is an autocomplete input form, that displays available categories. You can also cursor down to display a list
?>
	<li class="input"><input class="item-input" value="" tabindex="2" placeholder="Start typing or press down"></li>
</ul>
<?php //<input type="hidden" id="categories" name="data[CategoryPost][categoryids]" value="">?>
</div>



<?php
	/*
	 echo '<p><select name="categoryIds" id="categoryIds">';
	foreach ($categories AS $categoryId=>$categoryName)
	{
		if (array_key_exists($categoryId,$categoriesSelected))
		{
			$selected = "selected";
		}
		else
		{
			$selected = "";
		}
		echo "<option value='$categoryId' $selected>$categoryName</option>";
	}
	*/
?>

<!-- </select>
</p>
 -->

<?php

echo $this->Form->input('body', array('rows' => '20'));
echo $this->Form->input('id', array('type' => 'hidden'));
echo $this->Form->end('Save Post');


/*
 echo "<p>Category<br>";
echo $this->Form->select('category_id', $categories, array(
		'empty' => '(choose one)'
));
echo "</p>";
*/
//var_dump($categories);
//echo $this->Form->input('category_id');

/*
 echo $this->Form->input('category', array(
 		'empty' => '(choose one)'
 ));
*/

/* SIngle select, but it doesn't select the correct category */
//echo $this->Form->input('category');
?>