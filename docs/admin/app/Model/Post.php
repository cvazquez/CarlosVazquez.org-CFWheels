<?php
class Post extends AppModel {

	
	var $name = 'Post';


	/*public $hasAndBelongsToMany = array(
        'Category' =>
            array(
                'className' => 'Category',
                'joinTable' => 'categories_posts',
                'foreignKey' => 'post_id',
                'associationForeignKey' => 'category_id',
                'unique' => true,
                'conditions' => '',
                'fields' => '',
                'order' => '',
                'limit' => '',
                'offset' => '',
                'finderQuery' => '',
                'with' => ''
            )
    );*/
    
	
	/*
	public $validate = array(
        'title' => array(
            'rule' => 'notEmpty'
        ),
        'body' => array(
            'rule' => 'notEmpty'
        )
    );
    */
    
   var $hasAndBelongsToMany = array('Category');
    
    /*
    
    var $hasAndBelongsToMany = array('Tag'=>array(
                                      'joinTable'=>
                                               'my_cool_join_table'));
    */
    
    /*
    public $hasAndBelongsToMany = array(
        'Category' =>
            array(
                'className' => 'Category',
                'joinTable' => 'posts_to_categories',
                'foreignKey' => 'post_id',
                'associationForeignKey' => 'category_id',
            	'with' => 'PostToCategory',
            )
    );
    */
}
?>