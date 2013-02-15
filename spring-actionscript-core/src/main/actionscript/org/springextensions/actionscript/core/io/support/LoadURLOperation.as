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

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.setTimeout;

	import org.as3commons.lang.Assert;
	import org.springextensions.actionscript.core.operation.AbstractProgressOperation;

	/**
	 * An <code>IOperation</code> implementation that can load arbitrary data from a specified URL.
	 * @author Roland Zwaga
	 * @docref the_operation_api.html#operations
	 */
	public class LoadURLOperation extends AbstractProgressOperation {

		/**
		 * Internal <code>URLLoader</code> instance that is used to do the actual loading of the data.
		 */
		protected var urlLoader:URLLoader;

		/**
		 * Creates a new <code>LoadURLOperation</code> instance.
		 * @param url The specified URL from which the data will be loaded.
		 * @param dataFormat Optional argument that specifies the data format of the expected data. Use the <code>flash.net.URLLoaderDataFormat</code> enumeration for this.
		 * @see flash.net.URLLoaderDataFormat
		 */
		public function LoadURLOperation(url:String, dataFormat:String = null) {
			Assert.hasText(url, "url argument must not be null or empty");
			super();
			init(url, dataFormat);
		}

		/**
		 * Initializes the <code>LoadURLOperation</code> instance.
		 * @param url The specified URL from which the data will be loaded.
		 * @param dataFormat Optional argument that specifies the data format of the expected data. Use the <code>flash.net.URLLoaderDataFormat</code> enumeration for this. Default is "text".
		 * @see flash.net.URLLoaderDataFormat
		 */
		protected function init(url:String, dataFormat:String = "text"):void {
			dataFormat = (dataFormat == null) ? URLLoaderDataFormat.TEXT : dataFormat;
			urlLoader = new URLLoader();
			urlLoader.dataFormat = dataFormat;
			urlLoader.addEventListener(Event.COMPLETE, completeHandler);
			urlLoader.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);

			setTimeout(function():void {
				urlLoader.load(new URLRequest(url));
			}, 0);
		}

		/**
		 * Handles the <code>Event.COMPLETE</code> event of the internally created <code>URLLoader</code>.
		 * @param event The specified <code>Event.COMPLETE</code> event.
		 */
		protected function completeHandler(event:Event):void {
			result = urlLoader.data;
			removeEventListeners();
			dispatchCompleteEvent();
		}

		/**
		 * Handles the <code>ProgressEvent.PROGRESS</code> event of the internally created <code>URLLoader</code>.
		 * @param event The specified <code>ProgressEvent.PROGRESS</code> event.
		 */
		protected function progressHandler(event:ProgressEvent):void {
			progress = event.bytesLoaded;
			total = event.bytesTotal;
			dispatchProgressEvent();
		}

		/**
		 * Handles the <code>SecurityErrorEvent.SECURITY_ERROR</code> and <code>IOErrorEvent.IO_ERROR</code> events of the internally created <code>URLLoader</code>.
		 * @param event The specified <code>ProgressEvent.PROGRESS</code> or <code>IOErrorEvent.IO_ERROR</code> event.
		 */
		protected function errorHandler(event:Event):void {
			removeEventListeners();
			dispatchErrorEvent(event['text']);
		}

		/**
		 * Removes all the registered event handlers from the internally created <code>URLLoader</code> and
		 * sets itr to <code>null</code> afterwards.
		 */
		protected function removeEventListeners():void {
			if (urlLoader != null) {
				urlLoader.removeEventListener(Event.COMPLETE, completeHandler);
				urlLoader.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
				urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
				urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
				urlLoader = null;
			}
		}
	}
}