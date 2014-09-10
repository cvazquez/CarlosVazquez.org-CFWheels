<?php
class Category extends AppModel {

	var $name = 'Category';
	
	
	public $hasAndBelongsToMany = array(
        'Post' =>
            array(
                'className' => 'Post',
                'joinTable' => 'categories_posts',
                'foreignKey' => 'category_id',
                'associationForeignKey' => 'post_id',
                'unique' => true,
                'conditions' => '',
                'fields' => '',
                'order' => '',
                'limit' => '',
                'offset' => '',
                'finderQuery' => '',
                'with' => ''
            )
    );
    
	
	//var $hasAndBelongsToMany = array('Post');
	

	/*
	public $validate = array(
        'name' => array(
            'rule' => 'notEmpty'
        )
    );
    */
}

?>