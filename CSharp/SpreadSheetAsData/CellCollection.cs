﻿using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Packaging = DocumentFormat.OpenXml.Packaging;
using Spreadsheet = DocumentFormat.OpenXml.Spreadsheet;

namespace Marimo.SpreadSheetAsData
{
    public class CellCollection
    {
        Worksheet sheet;
        public CellCollection(Worksheet sheet)
        {
            this.sheet = sheet;
        }

        public Cell this[string cellReference]
        {
            get
            {
                var cellXml =
                    from cell in sheet.WorksheetPart.Worksheet.Descendants<Spreadsheet.Cell>()
                    where cell.CellReference == cellReference
                    select cell;
                return new Cell(sheet, cellXml.Single());
            }
        }

        public Cell this[int columnNumber, int rowNumber]
        {
            get
            {
                return this[GetCellReference(columnNumber, rowNumber)];
            }
        }

        private string GetCellReference(int columnNumber, int rowNumber)
        {
            return ((char)('A' - 1 + columnNumber)).ToString() + rowNumber;
        }
    }
}