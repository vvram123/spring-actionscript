/*
 * Copyright 2007-2010 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.springextensions.actionscript.core.io.support {

	import flash.events.IEventDispatcher;
	import flash.events.TimerEvent;
	import flash.system.ApplicationDomain;
	import flash.system.SecurityDomain;
	import flash.utils.Timer;

	import mx.core.FlexVersion;
	import mx.core.IFlexModuleFactory;
	import mx.events.StyleEvent;
	import mx.styles.StyleManager;

	import org.as3commons.lang.Assert;
	import org.springextensions.actionscript.core.operation.AbstractProgressOperation;
	import org.springextensions.actionscript.utils.ApplicationUtils;

	/**
	 * An <code>IOperation</code> implementation that can load a style module from a specified URL.
	 * @author Roland Zwaga
	 * @docref the_operation_api.html#operations
	 */
	public class LoadStyleModuleOperation extends AbstractProgressOperation {
		private static const GET_STYLE_MANAGER_METHOD:String = "getStyleManager";
		private static const LOAD_STYLE_DECLARATIONS_METHOD:String = "loadStyleDeclarations";

		protected var eventDispatcher:IEventDispatcher;

		protected var styleModuleURL:String;

		/**
		 * Creates a new <code>LoadStyleModuleOperation</code> instance.
		 * @param styleModuleURL
		 * @param update
		 * @param applicationDomain
		 * @param securityDomain
		 */
		public function LoadStyleModuleOperation(styleModuleURL:String, update:Boolean = true, applicationDomain:ApplicationDomain = null, securityDomain:SecurityDomain = null, flexModuleFactory:IFlexModuleFactory = null) {
			Assert.hasText(styleModuleURL, "the styleModuleURL argument cannot be null or empty");
			super();
			init(styleModuleURL, update, applicationDomain, securityDomain, flexModuleFactory);
		}

		protected function init(styleModuleURL:String, update:Boolean, applicationDomain:ApplicationDomain, securityDomain:SecurityDomain, flexModuleFactory:IFlexModuleFactory):void {
			flexModuleFactory = (flexModuleFactory == null) ? ApplicationUtils.application as IFlexModuleFactory : flexModuleFactory;
			this.styleModuleURL = styleModuleURL;
			var timer:Timer = new Timer(0);
			var timerHandler:Function = function(event:TimerEvent):void {
				timer.removeEventListener(TimerEvent.TIMER, timerHandler);
				timer.stop();
				timer = null;
				if (FlexVersion.CURRENT_VERSION > FlexVersion.VERSION_3_0) {
					eventDispatcher = StyleManager[GET_STYLE_MANAGER_METHOD](flexModuleFactory).loadStyleDeclarations2(styleModuleURL, update, applicationDomain, securityDomain);
				} else {
					eventDispatcher = StyleManager[LOAD_STYLE_DECLARATIONS_METHOD](styleModuleURL, update, false, applicationDomain, securityDomain);
				}
				eventDispatcher.addEventListener(StyleEvent.COMPLETE, completeHandler);
				eventDispatcher.addEventListener(StyleEvent.ERROR, errorHandler);
				eventDispatcher.addEventListener(StyleEvent.PROGRESS, progressHandler);
			}
			timer.addEventListener(TimerEvent.TIMER, timerHandler, false, 0, true);
			timer.start();
		}

		/**
		 * Handles the <code>StyleEvent.COMPLETE</code> event.
		 */
		protected function completeHandler(event:StyleEvent):void {
			removeEventListeners();
			dispatchCompleteEvent(styleModuleURL);
		}

		/**
		 * Handles the <code>StyleEvent.ERROR</code> event.
		 */
		protected function errorHandler(event:StyleEvent):void {
			removeEventListeners();
			dispatchErrorEvent(event.errorText);
		}

		/**
		 * Handles the <code>StyleEvent.PROGRESS</code> event.
		 */
		protected function progressHandler(event:StyleEvent):void {
			progress = event.bytesLoaded;
			total = event.bytesTotal;
			dispatchProgressEvent();
		}

		/**
		 * Removes the <code>StyleEvent.COMPLETE</code>, <code>StyleEvent.ERROR</code>
		 * and <code>StyleEvent.PROGRESS</code> event listeners.
		 */
		protected function removeEventListeners():void {
			if (eventDispatcher != null) {
				eventDispatcher.removeEventListener(StyleEvent.COMPLETE, completeHandler);
				eventDispatcher.removeEventListener(StyleEvent.ERROR, errorHandler);
				eventDispatcher.removeEventListener(StyleEvent.PROGRESS, progressHandler);
				eventDispatcher = null;
			}

		}
	}
}