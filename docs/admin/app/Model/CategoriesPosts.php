<?php
class CategoriesPosts extends AppModel {

	public $recursive = -1;
	
	
	public function saveCategories($categories = array(), $postId) 
	{
		if (!count($categories)) return;
		
		
		// Use the Cake PHP database config values to create a connection to MySQL
		$database = new DATABASE_CONFIG();
		$mysqli = new mysqli($database->default["host"], $database->default["login"], $database->default["password"], $database->default["database"]);
		
		if ($mysqli->connect_errno) {
			echo "Failed to connect to MySQL: (" . $mysqli->connect_errno . ") " . $mysqli->connect_error;
			exit;
		}
		 
		if (!($stmt = $mysqli->prepare("INSERT IGNORE INTO categories_posts (post_id, category_id, created) VALUES (?, ?, now())"))) {
			echo "Prepare failed: (" . $mysqli->errno . ") " . $mysqli->error;
			exit;
		}
		
		/* Bind the post id and category id to integers */
		if (!($bindMe = $stmt->bind_param("ii", $bindPostId, $categoryId))) {
			echo "Start of Binding failed: (" . $mysqli->errno . ") " . $mysqli->error;
			exit;
		}
		
		// Saving categories by looping through array list of selected categories
		foreach ($categories as $category => $v)
		{	
			$bindPostId = $postId;
			$categoryId = $v['id'];
				
				
			if (!$bindMe)
			{
				echo "Binding parameters failed: (" . $stmt->errno . ") " . $stmt->error;
				exit;
			}
				
			if (!$stmt->execute()) {
				echo "Execute failed: (" . $stmt->errno . ") " . $stmt->error;
				exit;
			}
				
			print_r($stmt);				
			
		}
		
		$stmt->close();

		
		/*
		if (!($stmt = $mysqli->prepare("INSERT IGNORE INTO categories_posts (post_id, category_id, created) VALUES (?, ?, now())"))) {
			echo "Prepare failed: (" . $mysqli->errno . ") " . $mysqli->error;
			exit;
		}
		
		// If you bind array-elements to a prepared statement, the array has to be declared first with the used keys:
		$arr = array("bindPostId"=>"","categoryId"=>"");
		
		if (!($bindMe = $stmt->bind_param("ii", $arr['bindPostId'], $arr['categoryId']))) {
			echo "Start of Binding failed: (" . $mysqli->errno . ") " . $mysqli->error;
			exit;
		}
		
		foreach ($categories as $category => $v)
		{		
			$arr[$category] = $v;
			
			if (!$stmt->execute()) {
				echo "Execute failed: (" . $stmt->errno . ") " . $stmt->error;
				exit;
			}
		
			
		}
		*/
		
		if ($mysqli->warning_count)
		{
			$errorSubject = "Warnings executing querying leads.";
			$errorMessage = print_r($this->mysqli,true);
		
			echo "<p>" . $errorMessage . "</p>";
			exit;
			/*
			$e = $this->mysqli->get_warnings();
			do {
				$errorMessage = $errorMessage . "\nWarning: $e->errno: $e->message\n";
			} while ($e->next());
		
			$this->emailError($errorSubject,$errorMessage);
			*/
		}
		
		$mysqli->close();
	}
}

?>