Class {
	#name : #BPAssembler,
	#superclass : #BPAbstractAssembler,
	#category : #'BytePusher-Assembler-Assembler'
}

{ #category : #accessing }
BPAssembler class >> defaultMemoryLayout [
	^ BPBytePusherLayout new
]

{ #category : #instructions }
BPAssembler >> add: source to: target [
	"Adds two numbers together and store result in source register.
	 This operations will modify the carry and zero flag. 
	 SP can be used as operand with ADD.

	ADD reg, reg
	ADD reg, address
	ADD reg, constant
	"
	BPAdd new
		source: source;
		target: target;
		generateFor: self
]

{ #category : #instructions }
BPAssembler >> atAddressStoreData: source [
	"Moves data in source to memory address located at address formed by registers A (high-byte), B (middle byte), C (low byte).
	"
	BPStoreDataAtAddress new
		source: source;
		generateFor: self
]

{ #category : #instructions }
BPAssembler >> call: address [
	BPCall new
		address: address;
		generateFor: self
]

{ #category : #instructions }
BPAssembler >> cmp: x with: y [
	"Compares two values and sets the zero flag to true if they are equal.
	 SP can be used as operand with CMP.
	 Use this instruction before a conditional jump.

	CMP reg, reg
	CMP reg, address
	CMP reg, constant
	"
	BPCmp new
		x: x;
		y: y;
		generateFor: self
]

{ #category : #instructions }
BPAssembler >> data: aByteArray [
	"Inject data in the bytecode.
	"
	BPDataZone new
		byteArray: aByteArray;
		generateFor: self
]

{ #category : #instructions }
BPAssembler >> decrement: register [
	"Decrement value stored in register.
	 This operations will modify the carry and zero flag. 

	DEC reg
	"
	BPDecrement new
		register: register;
		generateFor: self
]

{ #category : #instructions }
BPAssembler >> decrementAddress [
	"Decrement the address address formed by content of registers A (high-byte), B (middle byte), C (low byte)."
	
	| decrementAddressFinishedLabel |
	decrementAddressFinishedLabel := ('decrementAddressFinished-' , UUIDGenerator next asString) asSymbol.
	
	self
		decrement: #A;
		cmp: #A with: 255;
		jumpIfNotEqual: decrementAddressFinishedLabel;
		decrement: #B;
		cmp: #B with: 255;
		jumpIfNotEqual: decrementAddressFinishedLabel;
		decrement: #C;
		label: decrementAddressFinishedLabel;
		nop "Ensure it works even if this is the last instruction of program."
]

{ #category : #instructions }
BPAssembler >> decrementAddressAtDataStackTop [
	"Decrement the address address formed by content 3 top bytes of the stack.
		top of the stack -> address lower-byte
		                    address middle-byte
	                       address higher-byte
	 
	 Ensures that registers values are not modified.
	"
	self
		"Backup current values of A, B and C."
		pushOnDataStack: #A;
		pushOnDataStack: #B;
		pushOnDataStack: #C;
		decrement: #SP; decrement: #SP; decrement: #SP;
		"Increment address stored on the stack."
		popFromDataStack: #C;
		popFromDataStack: #B;
		popFromDataStack: #A;
		decrementAddress;
		pushOnDataStack: #A;
		pushOnDataStack: #B;
		pushOnDataStack: #C;
		"Restore A, B and C values."
		increment: #SP; increment: #SP; increment: #SP;
		popFromDataStack: #C;
		popFromDataStack: #B;
		popFromDataStack: #A
]

{ #category : #instructions }
BPAssembler >> fetchDataAtAddressAtDataStackTopInto: destination [
	"Moves data located at address formed by top 3 bytes of data stack to destination.
	 top of the stack -> address lower-byte
		                  address middle-byte
	                     address higher-byte
	 
	 Does not alter address stored on the stack.
	 Ensures that registers values are not modified.
	"
	self
		"Backup current values of A, B, C and D."
		pushOnDataStack: #A;
		pushOnDataStack: #B;
		pushOnDataStack: #C;
		pushOnDataStack: #D;
		decrement: #SP; decrement: #SP; decrement: #SP; decrement: #SP;
		"Fetch data at address stored on the stack."
		popFromDataStack: #C;
		popFromDataStack: #B;
		popFromDataStack: #A;
		fetchDataAtAddressInto: #D;
		pushOnDataStack: #A;
		pushOnDataStack: #B;
		pushOnDataStack: #C;
		"Save fetched value on the stack, without errasing A, B, C and D value saved previously."
		increment: #SP; increment: #SP; increment: #SP; increment: #SP;
		pushOnDataStack: #D;
		"Restore A, B, C and D values."
		decrement: #SP;
		popFromDataStack: #D;
		popFromDataStack: #C;
		popFromDataStack: #B;
		popFromDataStack: #A;
		increment: #SP; increment: #SP; increment: #SP; increment: #SP; increment: #SP;
		popFromDataStack: destination;
		decrement: #SP; decrement: #SP; decrement: #SP; decrement: #SP.
]

{ #category : #instructions }
BPAssembler >> fetchDataAtAddressInto: destination [
	"Moves data located at address formed by registers A (high-byte), B (middle byte), C (low byte) to destination.
	"
	BPFetchDataAtAddress new
		destination: destination;
		generateFor: self
]

{ #category : #instructions }
BPAssembler >> increment: register [
	"Increment value stored in register.
	 This operations will modify the carry and zero flag. 

	INC reg
	"
	BPIncrement new
		register: register;
		generateFor: self
]

{ #category : #instructions }
BPAssembler >> incrementAddress [
	"Increment the address address formed by content of registers A (high-byte), B (middle byte), C (low byte)."
	
	| incrementAddressFinishedLabel |
	incrementAddressFinishedLabel := ('incrementAddressFinished-' , UUIDGenerator next asString) asSymbol.
	
	self
		increment: #C;
		cmp: #C with: 0;
		jumpIfNotEqual: incrementAddressFinishedLabel;
		increment: #B;
		cmp: #B with: 0;
		jumpIfNotEqual: incrementAddressFinishedLabel;
		increment: #A;
		label: incrementAddressFinishedLabel;
		nop "Ensure it works even if this is the last instruction of program."
]

{ #category : #instructions }
BPAssembler >> incrementAddressAtDataStackTop [
	"Increment the address address formed by content 3 top bytes of the stack.
		top of the stack -> address lower-byte
		                    address middle-byte
	                       address higher-byte
	 
	 Ensures that registers values are not modified.
	"
	self
		"Backup current values of A, B and C."
		pushOnDataStack: #A;
		pushOnDataStack: #B;
		pushOnDataStack: #C;
		decrement: #SP; decrement: #SP; decrement: #SP;
		"Increment address stored on the stack."
		popFromDataStack: #C;
		popFromDataStack: #B;
		popFromDataStack: #A;
		incrementAddress;
		pushOnDataStack: #A;
		pushOnDataStack: #B;
		pushOnDataStack: #C;
		"Restore A, B and C values."
		increment: #SP; increment: #SP; increment: #SP;
		popFromDataStack: #C;
		popFromDataStack: #B;
		popFromDataStack: #A
]

{ #category : #instructions }
BPAssembler >> jump: address [
	"Let the instruction pointer do a unconditional jump to the defined address.

	 JMP address
	"
	BPJump new
		address: address;
		generateFor: self
]

{ #category : #instructions }
BPAssembler >> jumpIfEqual: address [
	"Let the instruction pointer do a jump to the defined address if ZERO flag is TRUE.

	 JE address
	"
	BPJumpIfEqual new
		address: address;
		generateFor: self
]

{ #category : #instructions }
BPAssembler >> jumpIfNotEqual: address [
	"Let the instruction pointer do a jump to the defined address if ZERO flag is FALSE.

	 JNE address
	"
	BPJumpIfNotEqual new
		address: address;
		generateFor: self
]

{ #category : #instructions }
BPAssembler >> move: source to: target [
	"Copies a value from src to dest.
	 The MOV instruction is the only one able to directly modify the memory.
	 SP can be used as operand with MOV.
	
	MOV <target> <source>
	======================
	MOV reg, reg
	MOV reg, address
	MOV reg, constant
	MOV address, reg
	MOV address, constant
	"
	BPMove new
		source: source;
		target: target;
		generateFor: self
]

{ #category : #instructions }
BPAssembler >> nop [
	"No-op instruction, does nothing.
	"
	BPNop new
		generateFor: self
]

{ #category : #instructions }
BPAssembler >> popFromDataStack: destination [
	BPPopFromDataStack new
		destination: destination;
		generateFor: self
]

{ #category : #instructions }
BPAssembler >> popFromReturnStack: destination [
	BPPopFromReturnStack new
		destination: destination;
		generateFor: self
]

{ #category : #instructions }
BPAssembler >> pushAddressOfLabelOnDataStack: label [
	"Push the memory address on the data stack in the following order: higher-byte, middle-byte, lower-byte.
	 So after the code related to this instruction is executed, the top of the stack contains:
	
	 	label address lower-byte <- top of the stack
		label address middle-byte
	   label address higher-byte
	"
	BPPushLabelAddressOnDataStack new
		label: label;
		generateFor: self
]

{ #category : #instructions }
BPAssembler >> pushAddressOfLabelOnReturnStack: label [
	BPPushLabelAddressOnReturnStack new
		label: label;
		generateFor: self
]

{ #category : #instructions }
BPAssembler >> pushAddressOfPCOnDataStack [
	| op |
	op := BPPushLabelAddressOnReturnStack new
		generateLabel;
		yourself.
	self label: op label.
	op
		generateFor: self
]

{ #category : #instructions }
BPAssembler >> pushOnDataStack: toPush [
	BPPushOnDataStack new
		toPush: toPush;
		generateFor: self
]

{ #category : #instructions }
BPAssembler >> pushOnReturnStack: toPush [
	BPPushOnReturnStack new
		toPush: toPush;
		generateFor: self
]

{ #category : #instructions }
BPAssembler >> readPixel [
	"Reads value of the pixel at the address pointed by 16bits address formed by A and B registers.
	 A register holds middle byte for address (Y coordinate).
	 B register holds lower byte for address (X coordinate).
	
	 The 0,0 coordinate is top-left on the screen. 
	
	 Stores the pixel value in register A.
	"
	BPReadPixel new
		generateFor: self
]

{ #category : #instructions }
BPAssembler >> return [
	BPReturn new
		generateFor: self
]

{ #category : #instructions }
BPAssembler >> serializePC: aSymbol [
	"Generates an instruction that saves the address of aLabel in PC reserved memory zone.
	 This is required to handle subroutines.
	"
	BPSerializePC new
		address: aSymbol;
		generateFor: self
]

{ #category : #instructions }
BPAssembler >> simpleAdd: source to: target [
	"Adds two numbers together and store result in source register.
	 This operations will NOT modify the carry and zero flag. 

	ADD reg, reg
	ADD reg, address
	ADD reg, constant
	"
	BPSimpleAdd new
		source: source;
		target: target;
		generateFor: self
	
]

{ #category : #instructions }
BPAssembler >> topFromDataStack: destination [
	"Copy top of the data stack to destination but do not remove the top element from the stack."
	BPPopFromDataStack new
		destination: destination;
		generateFor: self.
		
	self increment: #SP
]

{ #category : #instructions }
BPAssembler >> writePixel: pixelValue [
	"Writes #pixelValue on the pixel at the address pointed by 16bits address formed by A and B registers.
	 A register holds middle byte for address (Y coordinate).
	 B register holds lower byte for address (X coordinate).
	
	The 0,0 coordinate is top-left on the screen.
	"
	BPWritePixel new
		pixelValue: pixelValue;
		generateFor: self
]
