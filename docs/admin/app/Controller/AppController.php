<?php
/**
 * Application level Controller
 *
 * This file is application-wide controller file. You can put all
 * application-wide controller-related methods here.
 *
 * CakePHP(tm) : Rapid Development Framework (http://cakephp.org)
 * Copyright (c) Cake Software Foundation, Inc. (http://cakefoundation.org)
 *
 * Licensed under The MIT License
 * For full copyright and license information, please see the LICENSE.txt
 * Redistributions of files must retain the above copyright notice.
 *
 * @copyright     Copyright (c) Cake Software Foundation, Inc. (http://cakefoundation.org)
 * @link          http://cakephp.org CakePHP(tm) Project
 * @package       app.Controller
 * @since         CakePHP(tm) v 0.2.9
 * @license       http://www.opensource.org/licenses/mit-license.php MIT License
 */

App::uses('Controller', 'Controller');

/**
 * Application Controller
 *
 * Add your application-wide methods in the class below, your controllers
 * will inherit them.
 *
 * @package		app.Controller
 * @link		http://book.cakephp.org/2.0/en/controllers.html#the-app-controller
 */
class AppController extends Controller {
	
	 public $components = array(
	 			'DebugKit.Toolbar',
	 			'Session',
	 			'Auth' => array(
	 				'loginRedirect' => array(
	 						'controller' => 'posts',
	 						'action' => 'index'
	 				),
	 				'logoutRedirect' => array(
	 						'controller' => 'pages',
	 						'action' => 'display',
	 						'home'
	 				),
	 				'authenticate' => array(
	 						'Form' => array(
	 								'className' => 'Simple',
                    				'hashType' => 'sha1'
	 						)
	 				),
      				  'authorize' => array('Controller') // Added this line
	 				)
	 			);
	 
 
	 public function beforeFilter() {
	 	//$this->Auth->allow('index', 'view');	 

	 	parent::beforeFilter();
	 	
	 	
	 	/* Remove the DebugKit Toolbar if the IP Address is not allow to see it, based on IP's stored in the admin_settings table */
	 	
	 	/* Load the AdminSettings model which contains the debugIPAddress */
	 	$this->loadModel('AdminSetting');
	 	
	 	/* Retrieve one record with the field name/value  `name` = debugIPAddress */
	 	$post = $this->AdminSetting->find('first', array(	
	 						'conditions' => array('name' => 'debugIPAddress'),
	 						'fields' => array('value'),
	 			) 
	 			);
	 	
	 	/* If the users IP address is not equal to the debugIPAddress value, then display the DebugKit Toolbar */	 	
	 	if ($_SERVER['REMOTE_ADDR'] != $post["AdminSetting"]["value"])
	 	{
	 		$this->Components->unload('DebugKit.Toolbar');
	 	}
	 	
	 }
	 
	 public function isAuthorized($user) {
	 	// Admin can access every action
	 	if (isset($user['role']) && $user['role'] === 'admin') {
	 		return true;
	 	}
	 
	 	// Default deny
	 	return false;
	 }
}
