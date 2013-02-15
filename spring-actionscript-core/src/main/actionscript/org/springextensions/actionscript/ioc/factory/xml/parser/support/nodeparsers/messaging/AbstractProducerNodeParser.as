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
package org.springextensions.actionscript.ioc.factory.xml.parser.support.nodeparsers.messaging {
	
	import org.springextensions.actionscript.ioc.IObjectDefinition;
	import org.springextensions.actionscript.ioc.factory.xml.parser.support.ParsingUtils;
	import org.springextensions.actionscript.ioc.factory.xml.parser.support.XMLObjectDefinitionsParser;
	
	/**
	 * @docref xml-schema-based-configuration.html#the_messaging_schema
	 * @author Christophe Herreman
	 */
	public class AbstractProducerNodeParser extends MessageAgentNodeParser {
		
		public static const AUTO_CONNECT_ATTR:String = "auto-connect";
		
		public static const DEFAULT_HEADERS_ATTR:String = "default-headers";
		
		public static const PRIORITY_ATTR:String = "priority";
		
		public static const RECONNECT_ATTEMPTS_ATTR:String = "reconnect-attempts";
		
		public static const RECONNECT_INTERVAL_ATTR:String = "reconnect-interval";
		
		/**
		 * Creates a new AbstractProducerNodeParser
		 */
		public function AbstractProducerNodeParser() {
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function parseInternal(node:XML, context:XMLObjectDefinitionsParser):IObjectDefinition {
			var result:IObjectDefinition = IObjectDefinition(super.parseInternal(node, context));
			
			mapProperties(result, node);
			
			return result;
		}
		
		override protected function mapProperties(objectDefinition:IObjectDefinition, node:XML):void {
			super.mapProperties(objectDefinition, node);
			ParsingUtils.mapProperties(objectDefinition, node, AUTO_CONNECT_ATTR, PRIORITY_ATTR, RECONNECT_ATTEMPTS_ATTR, RECONNECT_INTERVAL_ATTR);
			ParsingUtils.mapReferences(objectDefinition, node, DEFAULT_HEADERS_ATTR);
		}

	}
}