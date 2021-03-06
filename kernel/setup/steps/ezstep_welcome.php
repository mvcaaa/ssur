<?php
//
// Definition of EZStepWelcome class
//
// Created on: <08-Aug-2003 15:00:02 kk>
//
// SOFTWARE NAME: eZ Publish
// SOFTWARE RELEASE: 4.0.1
// BUILD VERSION: 22260
// COPYRIGHT NOTICE: Copyright (C) 1999-2008 eZ Systems AS
// SOFTWARE LICENSE: GNU General Public License v2.0
// NOTICE: >
//   This program is free software; you can redistribute it and/or
//   modify it under the terms of version 2.0  of the GNU General
//   Public License as published by the Free Software Foundation.
//
//   This program is distributed in the hope that it will be useful,
//   but WITHOUT ANY WARRANTY; without even the implied warranty of
//   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//   GNU General Public License for more details.
//
//   You should have received a copy of version 2.0 of the GNU General
//   Public License along with this program; if not, write to the Free
//   Software Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
//   MA 02110-1301, USA.
//
//

/*! \file ezstep_welcome.php
*/

//include_once( 'kernel/setup/steps/ezstep_installer.php');
require_once( "kernel/common/i18n.php" );

/*!
  \class eZStepWelcome ezstep_welcome.php
  \brief The class eZStepWelcome does

*/
class eZStepWelcome extends eZStepInstaller
{

    /*!
     Constructor
     \reimp
    */
    function eZStepWelcome( $tpl, $http, $ini, &$persistenceList )
    {
        $this->eZStepInstaller( $tpl, $http, $ini, $persistenceList,
                                'welcome', 'Welcome' );
    }

    /*!
     \reimp
     */
    function processPostData()
    {
        if ( $this->Http->hasPostVariable( 'eZSetup_finetune_button' ) )
        {
            $this->PersistenceList['run_finetune'] = true;
        }

        if ( $this->Http->hasPostVariable( 'eZSetupWizardLanguage' ) )
        {
            $wizardLanguage = $this->Http->postVariable( 'eZSetupWizardLanguage' );
            $this->PersistenceList['setup_wizard'] = array( 'language' => $wizardLanguage );

            //include_once( 'lib/ezi18n/classes/eztranslatormanager.php' );
            eZTranslatorManager::setActiveTranslation( $wizardLanguage );
        }

        return true;
    }

    /*!
     \reimp
     */
    function init()
    {
        $optionalTests = eZSetupOptionalTests();
        $testTable = eZSetupTestTable();

        $optionalRunResult = eZSetupRunTests( $optionalTests, 'eZSetup:init:system_check', $this->PersistenceList );
        $this->OptionalResults = $optionalRunResult['results'];
        $this->OptionalResult = $optionalRunResult['result'];

        $testsRun = array();
        if ( isset( $this->Results ) && is_array( $this->Results ) )
        {
            foreach ( $this->Results as $testResultItem )
            {
                $testsRun[$testResultItem[1]] = $testResultItem[0];
            }
        }

        $this->PersistenceList['tests_run'] = $testsRun;
        $this->PersistenceList['optional_tests_run'] = $testsRun;

        return false; // Always show welcome message
    }

    /*!
     \reimp
    */
    function display()
    {
        $result = array();

        $languages = false;
        $defaultLanguage = false;
        $defaultExtraLanguages = false;

        eZSetupLanguageList( $languages, $defaultLanguage, $defaultExtraLanguages );

        //include_once( 'lib/ezi18n/classes/eztranslatormanager.php' );
        eZTranslatorManager::setActiveTranslation( $defaultLanguage, false );

        $this->Tpl->setVariable( 'language_list', $languages );
        $this->Tpl->setVariable( 'primary_language', $defaultLanguage );
        $this->Tpl->setVariable( 'optional_test', array( 'result' => $this->OptionalResult,
                                                         'results' => $this->OptionalResults ) );
        $result['content'] = $this->Tpl->fetch( 'design:setup/init/welcome.tpl' );
        $result['path'] = array( array( 'text' => ezi18n( 'design/standard/setup/init',
                                                          'Welcome to eZ Publish' ),
                                    'url' => false ) );

        return $result;
    }

    /*!
     \reimp
    */
    function showMessage()
    {
        return true;
    }

}

?>
