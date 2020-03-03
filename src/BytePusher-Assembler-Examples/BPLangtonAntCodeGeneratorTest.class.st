"
A BPLangtonAntCodeGeneratorTest is a test class for testing the behavior of BPLangtonAntCodeGenerator
"
Class {
	#name : #BPLangtonAntCodeGeneratorTest,
	#superclass : #TestCase,
	#category : #'BytePusher-Assembler-Examples'
}

{ #category : #test }
BPLangtonAntCodeGeneratorTest >> testGenerateInversePixelValueOn0 [
	| assembly vm memory generator |
	generator := BPLangtonAntCodeGenerator new.
	assembly := BPAssembler new.
	
	assembly
		pushOnDataStack: 0;
		call: #inverse_pixel_value;
		popFromDataStack: #A;
		jump: #end.
	
	generator generateInversePixelValueOn: assembly.
	
	assembly
		label: #end;
		nop.
	
	memory := assembly assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	vm step.
	
	self assert: ((assembly registerNamed: #A) valueIn: memory) equals: 215.
	self assert: (assembly memoryLayout extractDataStack: memory) isEmpty.
	self assert: (assembly memoryLayout extractReturnStack: memory) isEmpty.
]

{ #category : #test }
BPLangtonAntCodeGeneratorTest >> testGenerateInversePixelValueOn215 [
	| assembly vm memory generator |
	generator := BPLangtonAntCodeGenerator new.
	assembly := BPAssembler new.
	
	assembly
		pushOnDataStack: 215;
		call: #inverse_pixel_value;
		popFromDataStack: #A;
		jump: #end.
	
	generator generateInversePixelValueOn: assembly.
	
	assembly
		label: #end;
		nop.
	
	memory := assembly assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	vm step.
	
	self assert: ((assembly registerNamed: #A) valueIn: memory) equals: 0.
	self assert: (assembly memoryLayout extractDataStack: memory) isEmpty.
	self assert: (assembly memoryLayout extractReturnStack: memory) isEmpty.
]

{ #category : #test }
BPLangtonAntCodeGeneratorTest >> testGenerateNextAntPositionOn0 [
	| assembly vm memory generator |
	generator := BPLangtonAntCodeGenerator new.
	assembly := BPAssembler new.
	
	assembly
		pushOnDataStack: 0; "Direction: North"
		pushOnDataStack: 1; "y"
		pushOnDataStack: 1; "x"
		call: #next_ant_position;
		popFromDataStack: #A; "x"
		popFromDataStack: #B; "y"
		jump: #end.
	
	generator generateNextAntPositionOn: assembly.
	
	assembly
		label: #end;
		nop.
	
	memory := assembly assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	vm step.
	
	self assert: ((assembly registerNamed: #A) valueIn: memory) equals: 1.
	self assert: ((assembly registerNamed: #B) valueIn: memory) equals: 0.
	self assert: (assembly memoryLayout extractDataStack: memory) isEmpty.
	self assert: (assembly memoryLayout extractReturnStack: memory) isEmpty.
]

{ #category : #test }
BPLangtonAntCodeGeneratorTest >> testGenerateNextAntPositionOn1 [
	| assembly vm memory generator |
	generator := BPLangtonAntCodeGenerator new.
	assembly := BPAssembler new.
	
	assembly
		pushOnDataStack: 1; "Direction: East"
		pushOnDataStack: 1; "y"
		pushOnDataStack: 1; "x"
		call: #next_ant_position;
		popFromDataStack: #A; "x"
		popFromDataStack: #B; "y"
		jump: #end.
	
	generator generateNextAntPositionOn: assembly.
	
	assembly
		label: #end;
		nop.
	
	memory := assembly assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	vm step.
	
	self assert: ((assembly registerNamed: #A) valueIn: memory) equals: 2.
	self assert: ((assembly registerNamed: #B) valueIn: memory) equals: 1.
	self assert: (assembly memoryLayout extractDataStack: memory) isEmpty.
	self assert: (assembly memoryLayout extractReturnStack: memory) isEmpty.
]

{ #category : #test }
BPLangtonAntCodeGeneratorTest >> testGenerateNextAntPositionOn2 [
	| assembly vm memory generator |
	generator := BPLangtonAntCodeGenerator new.
	assembly := BPAssembler new.
	
	assembly
		pushOnDataStack: 2; "Direction: South"
		pushOnDataStack: 1; "y"
		pushOnDataStack: 1; "x"
		call: #next_ant_position;
		popFromDataStack: #A; "x"
		popFromDataStack: #B; "y"
		jump: #end.
	
	generator generateNextAntPositionOn: assembly.
	
	assembly
		label: #end;
		nop.
	
	memory := assembly assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	vm step.
	
	self assert: ((assembly registerNamed: #A) valueIn: memory) equals: 1.
	self assert: ((assembly registerNamed: #B) valueIn: memory) equals: 2.
	self assert: (assembly memoryLayout extractDataStack: memory) isEmpty.
	self assert: (assembly memoryLayout extractReturnStack: memory) isEmpty.
]

{ #category : #test }
BPLangtonAntCodeGeneratorTest >> testGenerateNextAntPositionOn3 [
	| assembly vm memory generator |
	generator := BPLangtonAntCodeGenerator new.
	assembly := BPAssembler new.
	
	assembly
		pushOnDataStack: 3; "Direction: West"
		pushOnDataStack: 1; "y"
		pushOnDataStack: 1; "x"
		call: #next_ant_position;
		popFromDataStack: #A; "x"
		popFromDataStack: #B; "y"
		jump: #end.
	
	generator generateNextAntPositionOn: assembly.
	
	assembly
		label: #end;
		nop.
	
	memory := assembly assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	vm step.
	
	self assert: ((assembly registerNamed: #A) valueIn: memory) equals: 0.
	self assert: ((assembly registerNamed: #B) valueIn: memory) equals: 1.
	self assert: (assembly memoryLayout extractDataStack: memory) isEmpty.
	self assert: (assembly memoryLayout extractReturnStack: memory) isEmpty.
]

{ #category : #test }
BPLangtonAntCodeGeneratorTest >> testGenerateTurnLeftProcedureOn0 [
	| assembly vm memory generator |
	generator := BPLangtonAntCodeGenerator new.
	assembly := BPAssembler new.
	
	assembly
		pushOnDataStack: 0;
		call: #turn_left;
		popFromDataStack: #A;
		jump: #end.
	
	generator generateTurnLeftProcedureOn: assembly.
	
	assembly
		label: #end;
		nop.
	
	memory := assembly assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	vm step.
	
	self assert: ((assembly registerNamed: #A) valueIn: memory) equals: 3.
	self assert: (assembly memoryLayout extractDataStack: memory) isEmpty.
	self assert: (assembly memoryLayout extractReturnStack: memory) isEmpty.
]

{ #category : #test }
BPLangtonAntCodeGeneratorTest >> testGenerateTurnLeftProcedureOn1 [
	| assembly vm memory generator |
	generator := BPLangtonAntCodeGenerator new.
	assembly := BPAssembler new.
	
	assembly
		pushOnDataStack: 1;
		call: #turn_left;
		popFromDataStack: #A;
		jump: #end.
	
	generator generateTurnLeftProcedureOn: assembly.
	
	assembly
		label: #end;
		nop.
	
	memory := assembly assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	vm step.
	
	self assert: ((assembly registerNamed: #A) valueIn: memory) equals: 0.
	self assert: (assembly memoryLayout extractDataStack: memory) isEmpty.
	self assert: (assembly memoryLayout extractReturnStack: memory) isEmpty.
]

{ #category : #test }
BPLangtonAntCodeGeneratorTest >> testGenerateTurnLeftProcedureOn2 [
	| assembly vm memory generator |
	generator := BPLangtonAntCodeGenerator new.
	assembly := BPAssembler new.
	
	assembly
		pushOnDataStack: 2;
		call: #turn_left;
		popFromDataStack: #A;
		jump: #end.
	
	generator generateTurnLeftProcedureOn: assembly.
	
	assembly
		label: #end;
		nop.
	
	memory := assembly assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	vm step.
	
	self assert: ((assembly registerNamed: #A) valueIn: memory) equals: 1.
	self assert: (assembly memoryLayout extractDataStack: memory) isEmpty.
	self assert: (assembly memoryLayout extractReturnStack: memory) isEmpty.
]

{ #category : #test }
BPLangtonAntCodeGeneratorTest >> testGenerateTurnLeftProcedureOn3 [
	| assembly vm memory generator |
	generator := BPLangtonAntCodeGenerator new.
	assembly := BPAssembler new.
	
	assembly
		pushOnDataStack: 3;
		call: #turn_left;
		popFromDataStack: #A;
		jump: #end.
	
	generator generateTurnLeftProcedureOn: assembly.
	
	assembly
		label: #end;
		nop.
	
	memory := assembly assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	vm step.
	
	self assert: ((assembly registerNamed: #A) valueIn: memory) equals: 2.
	self assert: (assembly memoryLayout extractDataStack: memory) isEmpty.
	self assert: (assembly memoryLayout extractReturnStack: memory) isEmpty.
]

{ #category : #test }
BPLangtonAntCodeGeneratorTest >> testGenerateTurnRightProcedureOn0 [
	| assembly vm memory generator |
	generator := BPLangtonAntCodeGenerator new.
	assembly := BPAssembler new.
	
	assembly
		pushOnDataStack: 0;
		call: #turn_right;
		popFromDataStack: #A;
		jump: #end.
	
	generator generateTurnRightProcedureOn: assembly.
	
	assembly
		label: #end;
		nop.
	
	memory := assembly assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	vm step.
	
	self assert: ((assembly registerNamed: #A) valueIn: memory) equals: 1.
	self assert: (assembly memoryLayout extractDataStack: memory) isEmpty.
	self assert: (assembly memoryLayout extractReturnStack: memory) isEmpty.
]

{ #category : #test }
BPLangtonAntCodeGeneratorTest >> testGenerateTurnRightProcedureOn1 [
	| assembly vm memory generator |
	generator := BPLangtonAntCodeGenerator new.
	assembly := BPAssembler new.
	
	assembly
		pushOnDataStack: 1;
		call: #turn_right;
		popFromDataStack: #A;
		jump: #end.
	
	generator generateTurnRightProcedureOn: assembly.
	
	assembly
		label: #end;
		nop.
	
	memory := assembly assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	vm step.
	
	self assert: ((assembly registerNamed: #A) valueIn: memory) equals: 2.
	self assert: (assembly memoryLayout extractDataStack: memory) isEmpty.
	self assert: (assembly memoryLayout extractReturnStack: memory) isEmpty.
]

{ #category : #test }
BPLangtonAntCodeGeneratorTest >> testGenerateTurnRightProcedureOn2 [
	| assembly vm memory generator |
	generator := BPLangtonAntCodeGenerator new.
	assembly := BPAssembler new.
	
	assembly
		pushOnDataStack: 2;
		call: #turn_right;
		popFromDataStack: #A;
		jump: #end.
	
	generator generateTurnRightProcedureOn: assembly.
	
	assembly
		label: #end;
		nop.
	
	memory := assembly assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	vm step.
	
	self assert: ((assembly registerNamed: #A) valueIn: memory) equals: 3.
	self assert: (assembly memoryLayout extractDataStack: memory) isEmpty.
	self assert: (assembly memoryLayout extractReturnStack: memory) isEmpty.
]

{ #category : #test }
BPLangtonAntCodeGeneratorTest >> testGenerateTurnRightProcedureOn3 [
	| assembly vm memory generator |
	generator := BPLangtonAntCodeGenerator new.
	assembly := BPAssembler new.
	
	assembly
		pushOnDataStack: 3;
		call: #turn_right;
		popFromDataStack: #A;
		jump: #end.
	
	generator generateTurnRightProcedureOn: assembly.
	
	assembly
		label: #end;
		nop.
	
	memory := assembly assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	vm step.
	
	self assert: ((assembly registerNamed: #A) valueIn: memory) equals: 0.
	self assert: (assembly memoryLayout extractDataStack: memory) isEmpty.
	self assert: (assembly memoryLayout extractReturnStack: memory) isEmpty.
]
