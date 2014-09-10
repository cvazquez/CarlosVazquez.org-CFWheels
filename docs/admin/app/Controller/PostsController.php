<?php
class PostsController extends AppController {
	
	// Include JQuery library	
	//public $helpers = array('Html' => 'Form', 'Js' => array('Jquery'));
 
    public function index() {
        $this->set('posts', $this->Post->find('all'));
    }
    
    public function view($id = null) {
        if (!$id) {
            throw new NotFoundException(__('Invalid post'));
        }

        $post = $this->Post->findById($id);
        if (!$post) {
            throw new NotFoundException(__('Invalid post'));
        }
        $this->set('post', $post);
    }
    
    public function add() {
        if ($this->request->is('post')) {
            $this->Post->create();
            if ($this->Post->save($this->request->data)) {
                $this->Session->setFlash(__('Your post has been saved.'));
                return $this->redirect(array('action' => 'index'));
            }
            $this->Session->setFlash(__('Unable to add your post.'));
        }
    }
    
    public function edit($id = null) {
	    if (!$id) {
        	throw new NotFoundException(__('Invalid post'));
    	}

	    $post = $this->Post->findById($id);
	    if (!$post) {
        	throw new NotFoundException(__('Invalid post'));
    	}
    	
    	
    	if ($this->request->is(array('post', 'put'))) {
    		
	        $this->Post->id = $id;
	        
	        $saveStatus = $this->Post->save($this->request->data);
	        
	        
        	if ($saveStatus ) {
        		
        		// Saving categories by looping through array list of selected categories
        		foreach ($this->request->data["Category"] as $category => $v)
        		{
        			//echo "$category=>$v[id]<br>";
        			
        			// Use the Cake PHP database config values to create a connection to MySQL
        			$database = new DATABASE_CONFIG();
        			$mysqli = new mysqli($database->default["host"], $database->default["login"], $database->default["password"], $database->default["database"]);
        			 
        			if ($mysqli->connect_errno) {
        				echo "Failed to connect to MySQL: (" . $mysqli->connect_errno . ") " . $mysqli->connect_error;
        			}
        			
        			if (!($stmt = $mysqli->prepare("INSERT IGNORE INTO categories_posts (post_id, category_id, created) VALUES (?, ?, now())"))) {
					     echo "Prepare failed: (" . $mysqli->errno . ") " . $mysqli->error;
					}
					
					$bindMe = $stmt->bind_param("ii", $postId, $categoryId);
					$postId = $this->Post->id;
					$categoryId = $v['id'];
					
					
					if (!$bindMe) 
					{						
						echo "Binding parameters failed: (" . $stmt->errno . ") " . $stmt->error;
					}					
					
					if (!$stmt->execute()) {
						echo "Execute failed: (" . $stmt->errno . ") " . $stmt->error;
					}
					
					print_r($stmt);
					
					$stmt->close();
        		}
        		//exit;
        		
        		
        		
	            $this->Session->setFlash(__('Your post has been updated.'));
            	return $this->redirect(array('action' => 'index'));
            	
            	/* Some code for trying to get the HABTM code to work. I will have to work on it later when I have more time 
         				
         				// Setup query for multi-select of category
				    	
				    	 /$this->set('categories', $this->Post->Category->find('list', array(
				       					 'order' => array('Category.name' => 'asc'))));
				       	
         				   	 		        
						//echo("<pre>");
				       // print_r($this->request->data);
				        //print_r($this->request->data["CategoryPost"]);
				       // print_r($saveStatus);
				        //echo("</pre>");
				        
				        
				        
				        //print_r($database);
				        
				        //print_r($database->default["host"]);
				        //print_r($database->default);
				        
				        echo("<pre>");
				        print_r($mysqli);
				        print_r($this->request->data["Category"]);
				        echo("</pre>");
				        
				        
				        
				        foreach ($this->request->data["Category"] as $category => $v)
				        {
				        	echo "$category=>$v[id]<br>";
				        	//echo "$this->request->data["Category"][$category]->id);
				        	//print_r($this->request->data["Category"][$category]);
			    			//echo($this->request->data["Category"][$category] . "<br>");
				        		
				        }
				        
			
			 	       	//$saveCategoryStatus = $this->CategoriesPosts->save($this->request->data["CategoryPost"]);
				        //$saveCategoryStatus = $this->CategoriesPosts->save($this->request->data);
				        //$saveCategoryStatus = $this->Category->save($this->request->data);

	        		echo("<pre>");
    	    		print_r($this->request->data);
        			print_r($saveStatus);
        			echo("</pre>");
        			exit;
        		
        		
        			//$categoryData = array('post_id' => $id, 'category_id' => $this->request->data->CategoryPost->categoryids);
        			//$this->CategoriesPosts->create($categoryData);
            	 */
            	
        	}
        	$this->Session->setFlash(__('Unable to update your post.'));
        	
    	}
    	else 
    	{
    		// Fetch all categories
    		$this->loadModel('Category');
    		$this->set('categories', $this->Category->find('list', array(
    				'order' => array('Category.name' => 'asc'))));
    		 
    		 
    		// Find the categpries already associated with this post
    		$this->loadModel('CategoriesPosts');
    		$conditions = array("post_id" => $id);
    		$fields = array('CategoriesPosts.category_id');
    		$this->set('categoriesSelected', $this->CategoriesPosts->find('list',
    				array(	'conditions' => $conditions,
    						'fields' => $fields)));
    	}

	    if (!$this->request->data) {
        	$this->request->data = $post;
    	}
    	
    	//$this->loadModel('PostCategory');
    	//$testcategories = $this->Post->Category->find('list');
    	
    	 
    	//$this->loadModel('PostCategory');
    	//$this->set('categoriesPosts', $this->CategoriesPosts->find('list'));

    	// Retrieve all categories for a select box
    	/*
    	 $this->loadModel('Category');
    	//$categories = $this->Category->find('list');
    	$this->set('categories', $this->Category->find('list', array(
    			'order' => array('Category.name' => 'asc'))));
    	*/
    	 
    	// Set Query for selection of Category
    	/*
    	 $conditions = array("post_id" => $id);
    	$fields = array('CategoriesPosts.category_id');
    	$this->loadModel('CategoriesPosts');
    	$this->set('postCategories', $this->CategoriesPosts->find('list',
    			array(	'conditions' => $conditions,
    					'fields' => $fields))
    			 
    	);
    	*/
    	
	}
	
	public function delete($id) 
	{
	    if ($this->request->is('get')) {
    	    throw new MethodNotAllowedException();
	    }

    		if ($this->Post->delete($id)) {
        		$this->Session->setFlash(
            	__('The post with id: %s has been deleted.', h($id))
    	    );
	        return $this->redirect(array('action' => 'index'));
    	}
	}
}
?>