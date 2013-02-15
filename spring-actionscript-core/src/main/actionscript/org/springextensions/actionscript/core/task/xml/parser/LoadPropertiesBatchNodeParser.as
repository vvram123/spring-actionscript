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
package org.springextensions.actionscript.core.task.xml.parser {
	import org.springextensions.actionscript.core.io.support.LoadPropertiesBatchOperation;
	import org.springextensions.actionscript.core.task.xml.TaskNamespaceHandler;
	import org.springextensions.actionscript.ioc.IObjectDefinition;
	import org.springextensions.actionscript.ioc.factory.xml.parser.support.XMLObjectDefinitionsParser;

	public class LoadPropertiesBatchNodeParser extends AbstractOperationNodeParser {

		public function LoadPropertiesBatchNodeParser() {
			super();
		}

		override protected function parseInternal(node:XML, context:XMLObjectDefinitionsParser):IObjectDefinition {
			super.parseInternal(node, context);
			builder.addConstructorArgValue(LoadPropertiesBatchOperation);
			var locations:String = node.attribute(TaskNamespaceHandler.LOCATIONS_ATTR);
			builder.addConstructorArgValue(locations.split(' ').join('').split(','));
			builder.addConstructorArgValue(node.attribute(TaskNamespaceHandler.IGNORE_RESOURCE_NOT_FOUND_ATTR) == "true");
			builder.addConstructorArgValue(node.attribute(TaskNamespaceHandler.PREVENT_CACHE_ATTR) == "true");
			return builder.objectDefinition;
		}

	}
}