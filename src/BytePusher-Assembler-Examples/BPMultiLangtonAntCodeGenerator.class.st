Class {
	#name : #BPMultiLangtonAntCodeGenerator,
	#superclass : #BPLangtonAntCodeGenerator,
	#category : #'BytePusher-Assembler-Examples'
}

{ #category : #'code generation' }
BPMultiLangtonAntCodeGenerator >> generateOn: assembly [
	"Read"
	"Inverse color"
	"Write new color"
	"Decide direction"
	"Move ant"
	assembly
		jump: #initialize;
			label: #ant1; nop;
			label: #ant2; nop;
			label: #ant3; nop;
			label: #ant4; nop;
		label: #initialize;
			serializePC: #iterate;
			"ant1"
			pushAddressOfLabelOnDataStack: #ant1;
			popFromDataStack: #C;
			popFromDataStack: #B;
			popFromDataStack: #A;
			atAddressStoreData: 0; "North"
			incrementAddress;
			atAddressStoreData: 100; "Y"
			incrementAddress;
			atAddressStoreData: 75; "X"
			"ant2"
			pushAddressOfLabelOnDataStack: #ant2;
			popFromDataStack: #C;
			popFromDataStack: #B;
			popFromDataStack: #A;
			atAddressStoreData: 1; "East"
			incrementAddress;
			atAddressStoreData: 150; "Y"
			incrementAddress;
			atAddressStoreData: 150; "X"
			"ant3"
			pushAddressOfLabelOnDataStack: #ant3;
			popFromDataStack: #C;
			popFromDataStack: #B;
			popFromDataStack: #A;
			atAddressStoreData: 2; "North"
			incrementAddress;
			atAddressStoreData: 75; "Y"
			incrementAddress;
			atAddressStoreData: 150; "X"
			jump: #end;
		
		label: #iterate;
			"ant1"
			pushAddressOfLabelOnDataStack: #ant1;
			call: #simulate_ant_at_address;
			"ant2"
			pushAddressOfLabelOnDataStack: #ant2;
			call: #simulate_ant_at_address;
			"ant3"
			pushAddressOfLabelOnDataStack: #ant3;
			call: #simulate_ant_at_address;
			jump: #end.
			
	self generateTurnLeftOn: assembly.
	self generateTurnRightOn: assembly.
	self generateTurnOn: assembly.
	self generateReadCurrentPixelValueOn: assembly.
	self generateNextAntPositionOn: assembly.
	self generateInversePixelValueOn: assembly.
	self generateWritePixelValueOn: assembly.
	self generateLangtonAntOn: assembly.
	self generateSimulateAntAtAddressOn: assembly.
	
	assembly
		label: #end;
		nop.
]

{ #category : #'as yet unclassified' }
BPMultiLangtonAntCodeGenerator >> generateSimulateAntAtAddressOn: assembly [
	assembly
		label: #simulate_ant_at_address;
		popFromDataStack: #C;
		popFromDataStack: #B;
		popFromDataStack: #A;
		"Backup ant address: we put back stack pointer where it was before poping A,B and C."
		simpleAdd: #SP to: 3;
		"Fetch ant data and put them on the stack."
		fetchDataAtAddressInto: #D;
		pushOnDataStack: #D;
		incrementAddress;
		fetchDataAtAddressInto: #D;
		pushOnDataStack: #D;
		incrementAddress;
		fetchDataAtAddressInto: #D;
		pushOnDataStack: #D;
		
		call: #langton_ant;
		popFromDataStack: #F;
		popFromDataStack: #E;
		popFromDataStack: #D;
		popFromDataStack: #C;
		popFromDataStack: #B;
		popFromDataStack: #A;
		atAddressStoreData: #D;
		incrementAddress;
		atAddressStoreData: #E;
		incrementAddress;
		atAddressStoreData: #F;
		return
]
